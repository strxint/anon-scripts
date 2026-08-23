#[ Lazy Anonymous tools for Linux, v4.0.0 ]#

info = { 
   "dev": "archnon@protonmail.com",
   "HasTor": "true",
   "HasI2pd": "true",
   "HasFirewall": "true",
   "firewall": "nft",
   "tor": "/etc/tor/torrc",
   "i2pd": "--daemon",
   "scriptsPathSuggested": "/usr/local/bin",
   "HasKillSwitch": "true",
   "SupportsIPv6": "false",
   "RemoteSSH": "iptables",
   "HasCopyright": "true",
   "IsLinuxOnly": "false",
   "IsLight": "true",
   "IsMinimal": "true",
   "IsPortable": "true",
   "lang": "bash",
};

scripts = {
   lazyanon, // script for Tor, i2pd, firewall and no ipv6, etc.
   anonman, // script for manage Torrc and firewall, etc.
   anondns, // script for making dns over Tor/i2pd, etc.
   lazymac // script for manage MAC changes, etc.
};

required = { 
   bash, // main scripting language.
   git, // clone repo
   root // for firewall, boot, ipv6, etc.
};

services = { 
   systemd, // systemctl 
   runit, // sv
   open-rc // rc-service, rc-update
};

package = { 
   apt, // debian
   apk, // alpine
   pacman, // arch
   emerge, // gentoo
   xbps-install, // void
   dnf, // RHEL
   yum, // RHEL
   zypper // open-suse
};

clone = git clone https://github.com/strxint/lazy-anon
