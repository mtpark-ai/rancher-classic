package firewall

import (
	"strings"
	"testing"
)

func TestBackendString(t *testing.T) {
	cases := map[Backend]string{
		Legacy:  "iptables-legacy",
		Nft:     "nftables",
		Mixed:   "mixed (both iptables-legacy and nftables active)",
		Unknown: "unknown",
	}
	for b, want := range cases {
		if got := b.String(); got != want {
			t.Errorf("Backend(%d).String() = %q, want %q", b, got, want)
		}
	}
}

func TestCountNonDefaultRules(t *testing.T) {
	out := `-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A INPUT -j DROP
-A INPUT -p tcp --dport 80 -j ACCEPT
-N CUSTOM
`
	if got := countNonDefaultRules([]byte(out)); got != 2 {
		t.Errorf("countNonDefaultRules: got %d rules, want 2", got)
	}
}

func TestCountNonDefaultRulesEmpty(t *testing.T) {
	out := `-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
`
	if got := countNonDefaultRules([]byte(out)); got != 0 {
		t.Errorf("countNonDefaultRules on empty: got %d, want 0", got)
	}
}

func TestCheckOrAbortIsSafeWhenBinariesMissing(t *testing.T) {
	// On a host without iptables/nft installed, CheckOrAbort should
	// not block startup; production runs inside a container that
	// inherits the host's binaries via privileged mount, but unit
	// tests cannot rely on that.
	if err := CheckOrAbort(); err != nil {
		// We tolerate either nil (no binaries detected) or a Mixed
		// error if the test host happens to have both backends with
		// rules — but never any other failure.
		if !strings.Contains(err.Error(), "mixed") {
			t.Fatalf("unexpected CheckOrAbort error: %v", err)
		}
	}
}
