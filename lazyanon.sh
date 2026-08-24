#!/bin/bash

##################################################################################################################################
# LazyAnon - bash based privacy tool.                                                                                            #
# Based in: bash.                                                                                                                #
# Requires: netcat-openbsd curl tor nftables procps networkmanager iproute2 coreutils util-linux bash sudo e2fsprogs i2pd        #
# Version: 4.0.0                                                                                                                 #
# Dev: archnon@protonmail.com                                                                                                    #
##################################################################################################################################
####################################################################
# Copyright (c) 2026 archnon@protonmail.com. All Rights Reserved.  #
####################################################################

# <-- colors -->

RED="\e[1;31m"

GREEN="\e[1;32m"

BLUE="\e[1;34m"

P="\e[1;35m"

YELLOW="\e[1;33m"

ORANGE="\e[38;5;214m"

LB="\e[1;36m"

WHITE="\e[1;37m"

NC="\e[0m"

# <-- Dependencies --> #
# Always dynamic #

if ! (command -v nc >/dev/null 2>&1 && command -v curl >/dev/null 2>&1 && command -v tor >/dev/null 2>&1 && command -v bash >/dev/null 2>&1 && command -v pkill >/dev/null 2>&1 && command -v sudo >/dev/null 2>&1 && command -v NetworkManager >/dev/null 2>&1 && command -v nft >/dev/null 2>&1 && command -v chattr >/dev/null 2>&1 && command -v i2pd >/dev/null 2>&1); then

  if [[ $(command -v apt) ]]; then

    pkgs=(netcat-openbsd tor curl nftables procps network-manager iproute2 coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! apt install "${pkgs[@]}" -y; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v pacman) ]]; then

    pkgs=(openbsd-netcat curl tor nftables procps-ng networkmanager iproute2 coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! pacman -Syy "${pkgs[@]}" --needed --noconfirm --overwrite "*"; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v dnf) ]]; then

    pkgs=(epel-release nmap-ncat curl tor nftables procps-ng NetworkManager iproute coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! dnf -y install --allowerasing "${pkgs[@]}"; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v yum) ]]; then

    pkgs=(nmap-ncat curl tor nftables procps-ng NetworkManager iproute coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! yum -y install "${pkgs[@]}"; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v zypper) ]]; then

    pkgs=(nmap-ncat curl tor nftables procps-ng NetworkManager iproute coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! zypper install "${pkgs[@]}"; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v apk) ]]; then

    pkgs=(netcat-openbsd curl tor nftables procps networkmanager iproute2 coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! apk add --no-cache "${pkgs[@]}"; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v xbps-install) ]]; then

    pkgs=(openbsd-netcat curl tor iproute2 coreutils util-linux bash nftables sudo procps-ng NetworkManager e2fsprogs i2pd)

    if ! xbps-install -Sy -f -y "*" "${pkgs[@]}"; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait

  elif [[ $(command -v emerge) ]]; then

    pkgs=(netcat-openbsd tor curl nftables procps network-manager iproute2 coreutils util-linux bash sudo e2fsprogs i2pd)

    if ! emerge -v --oneshot --keep-going ${pkgs[@]}; then
      echo -e "${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
    wait
  else
    pkgs=(netcat-openbsd tor curl nftables procps network-manager iproute2 coreutils util-linux bash sudo e2fsprogs i2pd)

    echo -e "${RED}[${WHITE}X${RED}] Unsuported package manager, install: ${ORANGE}${pkgs[@]}${NC}"
    exit 1
  fi
fi

# <-- Banner --> #

echo -e "${WHITE} ████                                 ${P}   █████████                                   "
echo -e "${WHITE}░░███                                 ${P}  ███░░░░░███                                  "
echo -e "${WHITE} ░███   ██████    █████████ █████ ████${P} ░███    ░███  ████████    ██████  ████████    "
echo -e "${WHITE} ░███  ░░░░░███  ░█░░░░███ ░░███ ░███ ${P} ░███████████ ░░███░░███  ███░░███░░███░░███   "
echo -e "${WHITE} ░███   ███████  ░   ███░   ░███ ░███ ${P} ░███░░░░░███  ░███ ░███ ░███ ░███ ░███ ░███   "
echo -e "${WHITE} ░███  ███░░███    ███░   █ ░███ ░███ ${P} ░███    ░███  ░███ ░███ ░███ ░███ ░███ ░███   "
echo -e "${WHITE} █████░░████████  █████████ ░░███████ ${P} █████   █████ ████ █████░░██████  ████ █████  "
echo -e "${WHITE}░░░░░  ░░░░░░░░  ░░░░░░░░░   ░░░░░███ ${P}░░░░░   ░░░░░ ░░░░ ░░░░░  ░░░░░░  ░░░░ ░░░░░   "
echo -e "${WHITE}                             ███ ░███ ${P}                                               "
echo -e "${WHITE}                            ░░██████  ${P}                                               "
echo -e "${WHITE}                             ░░░░░░   ${P}                                               "

echo -e "\e[95m╔══════════════════════════════════╗
║ \e[97mlazy and powerful anonymous tool\e[95m ║
╚══════════════════════════════════╝\e[0m"

echo -e "\e[97mᴅᴇᴠᴇʟᴏᴘᴇᴅ ʙʏ: \e[95mᴀʀᴄʜɴᴏɴ@ᴘʀᴏᴛᴏɴᴍᴀɪʟ.ᴄᴏᴍ\e[0m"

# Service Managers && Boot Automation

if [ ! -f /etc/systemd/system/lazyanon.service ] && command -v systemctl >/dev/null 2>&1; then
  touch /etc/systemd/system/lazyanon.service
  cat <<'EOT' >/etc/systemd/system/lazyanon.service
[Unit]
Description=lazy service for anonymous
[Service]
Type=forking
ExecStart=/usr/local/bin/lazyanon --launch
RemainAfterExit=yes
User=root
[Install]
WantedBy=multi-user.target
EOT
fi

if [ ! -f /etc/sv/lazyanon/run ] && command -v runit >/dev/null 2>&1; then
  mkdir -p /etc/sv/lazyanon/
  touch /etc/sv/lazyanon/run
  cat <<'EOT' >/etc/sv/lazyanon/run
#!/bin/sh
exec lazyanon --launch
EOT
  chmod +x /etc/sv/lazyanon/run
fi

if [ ! -f /etc/init.d/lazyanon ] && command -v rc-service >/dev/null 2>&1; then
  touch /etc/init.d/lazyanon
  cat <<'EOT' >/etc/init.d/lazyanon
#!/sbin/openrc-run
name=lazyanon
command="lazyanon"
command_args="--launch"
command_background=true
pidfile="/run/${RC_SVCNAME}.pid"
depend() {
   need net
}
EOT
  chmod +x /etc/init.d/lazyanon >/dev/null 2>&1
fi

# <-- Address To Bind -->
# Default: 127.0.0.1(loopback/lo/localhost) #
# There's no place like 127.0.0.1.. #

IFNAME=lo
ADDR=127.0.0.1

# <-- Tor Ports --> #
# Tor is not an http proxy btw #
# Default order: 6969, 5353, 9150, 9151, 8181 #

TRANS=6969
DNS=5353
SOCKS=9150
CONTROL=9151
HTTP=8181

# <-- Configuration Files --> #
# Always nftables instead of old iptables #
# Default order: /etc/tor/torrc, /etc/lazy_rules.nft #

TORRC=/etc/tor/torrc
FWFILE=/etc/lazy_rules.nft

# <-- Script Functions --> #
# Here logic becomes crazy #

# Torrc Check -->
torrc() {
  if ! $(tor --verify-config >/dev/null 2>&1); then
    echo -e "\n${RED}[${WHITE}X${RED}] Invalid Torrc${NC}"
    exit 1
  fi
}
# <--

# Help page -->
help_p() {
  echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${YELLOW}<${GREEN}COMMAND${YELLOW}> <${LB}OPTIONS${YELLOW}>${NC}"

  echo -e "\n${BLUE}[${ORANGE}1${BLUE}] ${LB}-l${BLUE}|${LB}--launch: ${WHITE}launch the ${P}lazy daemon${NC}"
  echo -e "\n${BLUE}[${ORANGE}2${BLUE}] ${LB}-q${BLUE}|${LB}--quit-lazy: ${WHITE}quit ${P}lazyanon ${NC}"
  echo -e "\n${BLUE}[${ORANGE}3${BLUE}] ${LB}-r${BLUE}|${LB}--relaunch: ${WHITE}launch ${P}lazy${WHITE} again${NC}"
  echo -e "\n${BLUE}[${ORANGE}4${BLUE}] ${LB}-e${BLUE}|${LB}--enable-boot: ${WHITE}get ${P}lazy ${WHITE}on boot${NC}"
  echo -e "\n${BLUE}[${ORANGE}5${BLUE}] ${LB}-d${BLUE}|${LB}--disable-boot: ${WHITE}dont get ${P}lazy ${WHITE}on boot${NC}"
  echo -e "\n${BLUE}[${ORANGE}6${BLUE}] ${LB}-i${BLUE}|${LB}--ip-info: ${WHITE}print your ${P}lazy IP${NC}"
  echo -e "\n${BLUE}[${ORANGE}7${BLUE}] ${LB}-n${BLUE}|${LB}--new-lazy: ${WHITE}get new ${P}lazy IP${NC}"
  exit 1
}
# <--

# Check IP -->
myip() {

  # Default API: 'ip-api.com?fields=query,asname,org,country,region,continent,proxy,mobile,status'
  # <- I recommend to get clear info ->

  check_ip='ip-api.com?fields=query,asname,org,country,region,continent,proxy,mobile,status'

  if pgrep -x tor >/dev/null 2>&1; then

    if ! curl --socks5-hostname $ADDR:$SOCKS $check_ip -w "\n" -s -m 5; then
      echo -e "\n${RED}[${WHITE}X${RED}]${WHITE} Could not check ${P}lazy IP ${WHITE}(timeout)${NC}"
      exit 1
    else
      exit 0
    fi
  else
    if ! curl $check_ip -w "\n" -s -m 5; then
      echo -e "\n${RED}[${WHITE}X${RED}]${WHITE} Could not check ${P}lazy IP ${WHITE}(timeout)${NC}"
      exit 1
    else
      exit 0
    fi
  fi

}
# <--

start() {

  # Goodbye SELinux ! #

  sudo setenforce 0 >/dev/null 2>&1
  sudo semanage permissive -a unconfined_t >/dev/null 2>&1

  # Ensuring Kernel modules before launching nft commands #

  modprobe nft_nat >/dev/null 2>&1
  modprobe nft_chain_nat >/dev/null 2>&1
  modprobe nf_nat >/dev/null 2>&1

  # Enforcing lazy firewall rules here #

  chattr -i $FWFILE >/dev/null 2>&1

  rm $FWFILE >/dev/null 2>&1
  touch $FWFILE >/dev/null 2>&1

  sudo nft flush ruleset >/dev/null 2>&1

  cat << 'EOT' > $FWFILE
table ip6 filter {
        chain INPUT {
                type filter hook input priority filter; policy drop;
                meta l4proto ipv6-icmp icmpv6 type echo-request counter packets 0 bytes 0 drop
        }

        chain FORWARD {
                type filter hook forward priority filter; policy drop;
        }

        chain OUTPUT {
                type filter hook output priority filter; policy drop;
        }
}
table ip filter {
        chain INPUT {
                type filter hook input priority filter; policy drop;
                iifname "$IFNAME" counter packets 0 bytes 0 accept
                ct state related,established counter packets 0 bytes 0 accept
                iifname "$IFNAME" ip protocol icmp icmp type echo-request ct state related,established counter packets 0 bytes 0 accept
                ip protocol icmp icmp type echo-request counter packets 0 bytes 0 drop
        }

        chain OUTPUT {
                type filter hook output priority filter; policy drop;
                oifname "$IFNAME" counter packets 0 bytes 0 accept
                ct state new,related,established counter packets 0 bytes 0 accept
                oifname "$IFNAME" ip protocol icmp icmp type echo-request ct state new,related,established counter packets 0 bytes 0 accept
                ip protocol icmp icmp type echo-request counter packets 0 bytes 0 drop
                skuid $TOR_USER counter packets 0 bytes 0 accept
                ip daddr $ADDR udp dport $DNS counter packets 0 bytes 0 accept
                ip daddr $ADDR tcp dport $TRANS counter packets 0 bytes 0 accept
                ip daddr $ADDR tcp dport $HTTP counter packets 0 bytes 0 accept
                counter packets 0 bytes 0 reject
        }

        chain FORWARD {
                type filter hook forward priority filter; policy drop;
        }
}
table ip nat {
        chain OUTPUT {
                type nat hook output priority dstnat; policy accept;
                ip daddr $ADDR udp dport 53 counter packets 0 bytes 0 redirect to :$DNS
                ip daddr $ADDR tcp dport 53 counter packets 0 bytes 0 redirect to :$DNS
                skuid $TOR_USER counter packets 0 bytes 0 return
                ip daddr 127.0.0.0/8 counter packets 0 bytes 0 return
                ip daddr 192.168.0.0/16 counter packets 0 bytes 0 return
                ip daddr 10.0.0.0/8 counter packets 0 bytes 0 return
                ip daddr 172.16.0.0/12 counter packets 100 bytes 100 return
                ip daddr 169.254.0.0/16 counter packets 0 bytes 0 return
                ip daddr 255.255.255.255 counter packets 0 bytes 0 return
                ip daddr 224.0.0.0/4 counter packets 0 bytes 0 return
		udp dport 53 counter packets 0 bytes 0 redirect to :$DNS
                tcp dport 53 counter packets 0 bytes 0 redirect to :$DNS
                tcp flags & (fin | syn | rst | ack) == syn counter packets 0 bytes 0 redirect to :$TRANS
                }
}
EOT

  ######## SSH Optional, delete if not needed ##########

  SSH=22

  sudo iptables -I INPUT -p tcp --dport $SSH -j ACCEPT >/dev/null 2>&1
  sudo iptables -I OUTPUT -p tcp --dport $$SSH -j ACCEPT >/dev/null 2>&1

  chattr +i $FWFILE >/dev/null 2>&1

  nft -f $FWFILE >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy firewall${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy firewall${NC}"

  sleep 1

  # Say goodbye to old PIDs and welcome to securest transparent proxy experience (i love my localhost) #

  pkill -9 tor >/dev/null 2>&1
  pkill -9 NetworkManager >/dev/null 2>&1

  chattr -i /etc/resolv.conf >/dev/null 2>&1

  rm /etc/resolv.conf >/dev/null 2>&1
  touch /etc/resolv.conf >/dev/null 2>&1

  echo -e "# lazy dns bruh.. #\nnameserver $ADDR" | tee /etc/resolv.conf >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy dns${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy dns${NC}"

  sleep 1

  chmod 644 /etc/resolv.conf >/dev/null 2>&1
  chattr +i /etc/resolv.conf >/dev/null 2>&1

  while ! pgrep -x NetworkManager >/dev/null 2>&1; do
    NetworkManager >/dev/null 2>&1 && continue || break
  done && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy network${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy network${NC}"

  sleep 1

  tor --User $TOR_USER --RunAsDaemon 1 --DataDirectory /var/lib/tor -f $TORRC >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy tor${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy tor${NC}"
  i2pd --daemon >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy i2pd${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy i2pd${NC}"

  sleep 1

  sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
  sysctl -w net.ipv4.icmp_echo_ignore_all=1 >/dev/null 2>&1
  sysctl -w net.ipv6.icmp.echo_ignore_all=1 >/dev/null 2>&1
  sysctl -w net.ipv6.conf.lo.disable_ipv6=1 >/dev/null 2>&1
  sysctl --system >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy ipv6${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy ipv6${NC}"

  sleep 1

  # Proxy PID simple check to confirm everything works #

  if pgrep -x tor >/dev/null 2>&1 && pgrep -a i2pd >/dev/null 2>&1; then

    sleep 1

    echo -e "\n${BLUE}[${LB}OK${BLUE}]${LB} lazy daemon, all done${NC}"

  else
    sleep 1

    echo -e "${RED}[${WHITE}X${RED}] lazy daemon, try again${NC}"
    exit 1
  fi
}

# Apply Default Torrc if user have not used anonman to apply a custom one #

config() {

  # here the check #

  if ! cat $TORRC | grep -IE "NOT TOUCH, THIS FILE IS CUSTOM LOAD" >/dev/null 2>&1; then

    chattr -i $TORRC >/dev/null 2>&1

    rm $TORRC >/dev/null 2>&1
    touch $TORRC >/dev/null 2>&1

    # default template #

cat << 'EOT' >$TORRC
# lazy man.. #
# File locked by chattr +i, unlock: sudo chattr -i $TORRC

CookieAuthentication 0
VirtualAddrNetworkIPv4 10.192.0.0/10
AutomapHostsOnResolve 1
AutomapHostsSuffixes .exit,.onion
TransPort $ADDR:$TRANS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
DNSPort $ADDR:$DNS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
SocksPort $ADDR:$SOCKS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
ControlPort $ADDR:$CONTROL
HTTPTunnelPort $ADDR:$HTTP
EntryNodes {is},{ch},{fi},{ro}
ExitNodes {is},{ch},{fi},{ro}
StrictNodes 1
MaxCircuitDirtiness 10
ClientUseIPv6 0
ClientPreferIPv6ORPORT 0
ClientRejectInternalAddresses 1
AvoidDiskWrites 1
EnforceDistinctSubnets 1
HardwareAccel 1

EOT

    chattr +i $TORRC >/dev/null 2>&1

  fi

  # Tor user detection(for firewall rules) #

  if id debian-tor >/dev/null 2>&1; then
    export TOR_USER="debian-tor"
    echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy guy: ${GREEN}$TOR_USER${NC}"

  elif id tor >/dev/null 2>&1; then
    export TOR_USER="tor"
    echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy guy: ${GREEN}$TOR_USER${NC}"

  elif id toranon >/dev/null 2>&1; then
    export TOR_USER="toranon"
    echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy guy: ${GREEN}$TOR_USER${NC}"

  else
    echo -e "\n${RED}[${WHITE}X${RED}] No lazy guy?${NC}"
    read -e -p $'\n\e[1;31m[\e[1;33mwarn\e[1;31m]\e[1;37m Oops!, enter a system user: \e[1;32m' TOR_USER $TOR_USER

    if id $TOR_USER >/dev/null 2>&1; then
      export TOR_USER=$TOR_USER
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} alr, lazy guy: ${GREEN}$TOR_USER${NC}"

    else
      echo -e "\n${RED}[${WHITE}X${RED}] There is no lazy guy ${ORANGE}'$TOR_USER'${NC}"
      exit 1

    fi

  fi

  chown -R $TOR_USER:$TOR_USER $TORRC >/dev/null 2>&1
  chown -R $TOR_USER:$TOR_USER /var/lib/tor >/dev/null 2>&1
  chmod 700 /var/lib/tor >/dev/null 2>&1

  sleep 1

  start
}

stop() {

  # Check if tor is even running #

  if pgrep -x tor >/dev/null 2>&1; then

    sleep 1

    # Everything starts being normal from here #

    pkill -9 tor >/dev/null 2>&1
    pkill -9 NetworkManager >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy tor, network${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy tor, network${NC}"

    sleep 1

    chattr -i /etc/resolv.conf >/dev/null 2>&1
    rm /etc/resolv.conf >/dev/null 2>&1
    touch /etc/resolv.conf >/dev/null 2>&1

    echo nameserver 9.9.9.9 | sudo tee /etc/resolv.conf >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy dns${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy dns${NC}"

    sleep 1

    chattr +i /etc/resolv.conf >/dev/null 2>&1

    while ! pgrep -x NetworkManager >/dev/null 2>&1; do
      NetworkManager >/dev/null 2>&1 && continue || break
    done && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy network${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy network${NC}"

    sysctl -w net.ipv6.conf.all.disable_ipv6=0 >/dev/null 2>&1
    sysctl -w net.ipv4.icmp_echo_ignore_all=0 >/dev/null 2>&1
    sysctl -w net.ipv6.icmp.echo_ignore_all=0 >/dev/null 2>&1
    sysctl -w net.ipv6.conf.lo.disable_ipv6=0 >/dev/null 2>&1
    sysctl --system >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy ipv6${NC}" || echo -e "\n${RED}[${WHITE}X${RED}]${P} lazy ipv6${NC}"

    sudo nft flush ruleset >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy firewall${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy firewall${NC}"

    if ! pgrep -x tor >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You are not lazy, man${NC}"
      exit 0
    else
      echo -e "\n${RED}[${WHITE}X${RED}] You still lazy, try again${NC}"
      exit 1
    fi

  else
    echo -e "\n${RED}[${WHITE}X${RED}] You are not lazy, man${NC}"
    exit 1
  fi

}

# <-- Function Calls (arguments) --> #

while [ $# -gt 0 ]; do
  case $1 in
  -l | -launch | --launch)
    mode=1

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    torrc

    if ! pgrep -x tor >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} getting so lazy..${NC}"
      config
      exit 0
    else
      echo -e "\n${RED}[${YELLOW}warn${RED}]${P} You are a lazy man${NC}"
      exit 1
    fi

    shift
    break

    ;;

  -q | -quit-lazy | --quit-lazy)

    mode=2

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    stop

    shift
    break

    ;;

  -i | -ip-info | --ip-info)

    mode=3

    myip

    shift
    break

    ;;

  -n | -new-lazy | --new-lazy)

    mode=4

    if pgrep -x tor >/dev/null 2>&1; then
      echo -e "AUTHENTICATE \"\"\nSIGNAL NEWNYM\nQUIT" | nc $ADDR $CONTROL >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} new lazy IP${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] no new lazy IP${NC}"
    else
      echo -e "\n${RED}[${WHITE}X${RED}] You are not lazy${NC}"
      exit 1
    fi

    shift
    break

    ;;

  -e | -enable-boot | --enable-boot)

    mode=5

    if [ "$EUID" -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    torrc

    if [ -f /etc/systemd/system/lazyanon.service ] && command -v systemctl >/dev/null 2>&1; then

      if systemctl is-enabled lazyanon >/dev/null 2>&1; then
        echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You are lazy${NC}"
        exit 1
      else
        systemctl enable lazyanon >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You got a lazy boot${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You didnt got a lazy boot${NC}"
      fi

    fi

    if [ -f /etc/sv/lazyanon/run ] && command -v runit >/dev/null 2>&1; then

      if [ -d /run/runit/service ]; then
        export RSDIR=/run/runit/service
      elif [ -d /etc/service ]; then
        export RSDIR=/etc/service
      elif [ -d /var/run/service ]; then
        export RSDIR=/var/run/service
      fi

      if ls -l $RSDIR/lazyanon/ >/dev/null 2>&1; then
        echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You are lazy${NC}"
      else
        ln -s /etc/sv/lazyanon $RSDIR >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You got a lazy boot${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You didnt got a lazy boot${NC}"
      fi
    fi

    if [ -f /etc/init.d/lazyanon ] && command -v rc-update >/dev/null 2>&1; then

      if sudo rc-update | grep -IE "lazyanon" >/dev/null 2>&1; then
        echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You are lazy${NC}"
      else
        sudo rc-update add lazyanon default >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You got a lazy boot${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You didnt got a lazy boot${NC}"
      fi

    fi

    shift
    break

    ;;

  -d | -disable-boot | --disable-boot)

    # You cannot run this as an standard user #

    mode=6

    if [ "$EUID" -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if [ -f /etc/systemd/system/lazyanon.service ] && command -v systemctl >/dev/null 2>&1; then

      if ! systemctl is-enabled lazyanon >/dev/null 2>&1; then
        echo -e "\n${RED}[${WHITE}X${RED}] You are not lazy${NC}"
        exit 0
      else
        systemctl disable lazyanon >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You are not lazy${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You still lazy${NC}"
        exit 0
      fi
    fi

    if [ -f /etc/sv/lazyanon/run ] && command -v runit >/dev/null 2>&1; then

      if [ -d /run/runit/service ]; then
        RSDIR=/run/runit/service
      elif [ -d /etc/service ]; then
        RSDIR=/etc/service
      elif [ -d /var/run/service ]; then
        RSDIR=/var/run/service
      fi

      if ! ls -l $RSDIR/lazyanon/ >/dev/null 2>&1; then
        echo -e "\n${RED}[${WHITE}X${RED}] You are not lazy${NC}"
        exit 0
      else

        rm -rf $RSDIR/lazyanon >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You are not lazy${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You still lazy${NC}"
        exit 0
      fi

    fi

    if [ -f /etc/init.d/lazyanon ] && command -v rc-service >/dev/null 2>&1; then

      if ! rc-update | grep -IE "lazyanon" >/dev/null 2>&1; then
        echo -e "\n${RED}[${WHITE}X${RED}] You are no lazy${NC}"
        exit 0
      else
        rc-update del lazyanon default >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} You are not lazy${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You still lazy${NC}"
        exit 0
      fi

    fi

    shift
    break

    ;;

  -r | -relaunch | --relaunch)

    # You cannot run this as an standard user #

    mode=7

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    torrc

    echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} getting so lazy again..${NC}"

    pkill -9 tor >/dev/null 2>&1
    pkill -9 NetworkManager >/dev/null 2>&1

    config

    shift
    break

    ;;

  -h | -help | --help)
    mode=9

    help_p

    shift
    break

    ;;

  --* | -* | *)
    mode=10

    echo -e "\n${RED}[${WHITE}X${RED}] You are not lazy: ${YELLOW}'$1'${RED}, try ${LB}'$0 --help'${NC}"

    exit 1

    shift
    break

    ;;

  esac
done

# Help page if ! mode = true
if [[ -z "$mode" ]]; then
  help_p
fi
