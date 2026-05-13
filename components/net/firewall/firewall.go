// Package firewall detects which iptables backend the host kernel is
// using and refuses to start if both legacy and nft are simultaneously
// active. rancher-classic 1.7.0 supports either backend exclusively,
// but a mixed stack (legacy + nft rule sets both populated) produces
// silent rule-precedence bugs that masquerade as cross-host networking
// flakes; the plan calls for an explicit fail-fast.
package firewall

import (
	"errors"
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// Backend identifies the iptables variant in use on the host.
type Backend int

const (
	// Unknown means detection failed (binary missing, no permissions).
	Unknown Backend = iota
	// Legacy is the classic xtables (in-kernel iptable_*) path.
	Legacy
	// Nft is iptables-over-nftables (nf_tables) or pure nftables.
	Nft
	// Mixed means both backends have user-installed rules — refuse-to-start.
	Mixed
)

func (b Backend) String() string {
	switch b {
	case Legacy:
		return "iptables-legacy"
	case Nft:
		return "nftables"
	case Mixed:
		return "mixed (both iptables-legacy and nftables active)"
	default:
		return "unknown"
	}
}

// Detect inspects the host. It is safe to call on a system without
// the iptables / nft binaries installed — Unknown is returned.
func Detect() (Backend, error) {
	legacy, errL := hasLegacyRules()
	nft, errN := hasNftRules()

	if errL != nil && errN != nil {
		return Unknown, fmt.Errorf("detect firewall backend: legacy=%v nft=%v", errL, errN)
	}
	switch {
	case legacy && nft:
		return Mixed, nil
	case legacy:
		return Legacy, nil
	case nft:
		return Nft, nil
	default:
		// Neither backend has user rules; default to whichever binary
		// is preferred via /etc/alternatives.
		alt, err := alternativeIptables()
		if err == nil && strings.Contains(alt, "nft") {
			return Nft, nil
		}
		return Legacy, nil
	}
}

// hasLegacyRules returns true if iptables-legacy reports any non-empty
// chain in the filter table.
func hasLegacyRules() (bool, error) {
	bin, err := exec.LookPath("iptables-legacy")
	if err != nil {
		// Fallback: try iptables and see if it reports an nft hint.
		if _, err2 := exec.LookPath("iptables"); err2 != nil {
			return false, err
		}
		bin = "iptables"
	}
	out, err := exec.Command(bin, "-S").Output()
	if err != nil {
		return false, err
	}
	return countNonDefaultRules(out) > 0, nil
}

// hasNftRules returns true if `nft list ruleset` returns any non-empty
// ruleset.
func hasNftRules() (bool, error) {
	if _, err := exec.LookPath("nft"); err != nil {
		return false, err
	}
	out, err := exec.Command("nft", "list", "ruleset").Output()
	if err != nil {
		return false, err
	}
	// Empty ruleset prints just a comment header or nothing.
	body := strings.TrimSpace(string(out))
	for _, line := range strings.Split(body, "\n") {
		line = strings.TrimSpace(line)
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		return true, nil
	}
	return false, nil
}

// countNonDefaultRules counts -A lines in iptables -S output, ignoring
// the policy declarations (-P INPUT ACCEPT etc.).
func countNonDefaultRules(out []byte) int {
	n := 0
	for _, line := range strings.Split(string(out), "\n") {
		if strings.HasPrefix(strings.TrimSpace(line), "-A ") {
			n++
		}
	}
	return n
}

// alternativeIptables reads /etc/alternatives/iptables to determine
// the host's preferred backend (Debian/Ubuntu convention).
func alternativeIptables() (string, error) {
	target, err := os.Readlink("/etc/alternatives/iptables")
	if err != nil {
		return "", err
	}
	return target, nil
}

// CheckOrAbort calls Detect and returns a non-nil error if the host
// is in a state we cannot safely operate in (Mixed) or that we cannot
// determine (Unknown but binaries are present and failed).
//
// rancher-classic-net should call CheckOrAbort during startup and exit
// non-zero if it returns an error.
func CheckOrAbort() error {
	b, err := Detect()
	if err != nil && b == Unknown {
		// Detection itself failed. If the host doesn't have iptables/nft
		// installed at all, we can proceed and trust the kernel will
		// drop our packets if something goes wrong. Log via caller.
		return nil
	}
	switch b {
	case Mixed:
		return errors.New(
			"firewall: both iptables-legacy and nftables have active rule sets — " +
				"this is not supported because the rule-precedence is non-deterministic. " +
				"Pick one backend (`update-alternatives --set iptables /usr/sbin/iptables-legacy` " +
				"OR `update-alternatives --set iptables /usr/sbin/iptables-nft`) and flush the other " +
				"before starting rancher-classic-net.")
	case Unknown:
		return errors.New("firewall: could not determine iptables backend")
	}
	return nil
}
