#!/bin/bash

###############################################################################################################################
#                                                                                                                             #
# ANONYMOUS MANAGER - Simple Anonymous Torrc & Firewall manager                                                               #
# CODED BY: archnon@protonmail.com                                                                                            #
#                                                                                                                             #
###############################################################################################################################
####################################################################
# Copyright (c) 2026 archnon@protonmail.com. All Rights Reserved.  #
####################################################################

# Colors

RED="\e[1;31m"

GREEN="\e[1;32m"

BLUE="\e[1;34m"

P="\e[1;35m"

WHITE="\e[1;37m"

YELLOW="\e[1;33m"

ORANGE="\e[38;5;214m"

LB="\e[36m"

NC="\e[0m"

##### Dependencies && package managers ######

pkgs=(e2fsprogs)

if ! (command -v chattr >/dev/null 2>&1); then
  if [[ $(command -v apt) ]]; then
    if ! apt install -y ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v pacman) ]]; then
    if ! pacman -Sy --noconfirm --needed --overwrite "*" ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v dnf) ]]; then
    if ! dnf install -y --allowerasing ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v yum) ]]; then
    if ! yum install -y ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v xbps-install) ]]; then
    if ! xbps-install -Sy -f -y "*" ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v zypper) ]]; then
    if ! zypper install ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v apk) ]]; then
    if ! apk add --no-cache figlet; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  elif [[ $(command -v emerge) ]]; then
    if ! emerge -v --oneshot --keep-going ${pkgs[@]}; then
      echo -e "\n${RED}[${NC}-${RED}] Could not install: ${ORANGE}${pkgs[@]}${NC}"
      exit 1
    fi
  else
    echo -e "\n${RED}[${NC}-${RED}] Unsuported package manager, install: ${ORANGE}'${pkgs[@]}'${NC}"
    exit 1
  fi
fi

##### Banner ######

echo -e "${RED}   █████████                                  ██████   ██████                     "
echo -e "${RED}  ███░░░░░███                                ░░██████ ██████                      "
echo -e "${RED} ░███    ░███  ████████    ██████  ████████   ░███░█████░███   ██████   ████████  "
echo -e "${RED} ░███████████ ░░███░░███  ███░░███░░███░░███  ░███░░███ ░███  ░░░░░███ ░░███░░███ "
echo -e "${RED} ░███░░░░░███  ░███ ░███ ░███ ░███ ░███ ░███  ░███ ░░░  ░███   ███████  ░███ ░███ "
echo -e "${RED} ░███    ░███  ░███ ░███ ░███ ░███ ░███ ░███  ░███      ░███  ███░░███  ░███ ░███ "
echo -e "${RED} █████   █████ ████ █████░░██████  ████ █████ █████     █████░░████████ ████ █████"
echo -e "${RED}░░░░░   ░░░░░ ░░░░ ░░░░░  ░░░░░░  ░░░░ ░░░░░ ░░░░░     ░░░░░  ░░░░░░░░ ░░░░ ░░░░░ "
echo -e "${RED}                                                                                  "
echo -e "${RED}                                                                                  "
echo -e "${RED}                                                                                  "

echo -e "\e[91m╔════════════════════════════╗
║ \e[92mTorrc and firewall manager\e[91m ║
╚════════════════════════════╝\e[0m"
echo -e "\e[97mᴅᴇᴠᴇʟᴏᴘᴇᴅ ʙʏ: \e[95mᴀʀᴄʜɴᴏɴ@ᴘʀᴏᴛᴏɴᴍᴀɪʟ.ᴄᴏᴍ\e[0m"

# Bind Addr
# Default 127.0.0.1(loopback/lo/localhost)

ADDR=127.0.0.1

# Tor Ports
# Default order: 6969, 5353, 9150, 9151, 8181

TRANS=6969
DNS=5353
SOCKS=9150
CONTROL=9151
HTTP=8181

# Configuration Files
# Default: /etc/tor/torrc, /etc/lazy_rules.nft, /etc/resolv.conf

TORRC=/etc/tor/torrc
FWFILE=/etc/lazy_rules.nft
DNS=/etc/resolv.conf

# Usage Warn

usage() {
  echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${P}$0 ${NC}<${GREEN}COMMAND${NC}> <${P}OPTIONS${NC}>${NC}"
  echo -e "\n${BLUE}[${ORANGE}1${BLUE}]${LB} -r${BLUE}|${LB}--torrc-reset: ${ORANGE}apply default template for torrc${NC}"
  echo -e "\n${BLUE}[${ORANGE}2${BLUE}]${LB} -p${BLUE}|${LB}--print ${NC}<${P}arg${NC}>: ${ORANGE}show some object or file${NC}"
  echo -e "\n${BLUE}[${ORANGE}4${BLUE}]${LB} -f${BLUE}|${LB}--load-torrc ${NC}<${P}arg${NC}>: ${ORANGE}Load ${P}custom Torrc${NC}"
  echo -e "\n${BLUE}[${ORANGE}5${BLUE}]${LB} -b${BLUE}|${LB}--load-bridges: ${ORANGE}Load ${P}custom Bridges for Torrc${NC}"
  echo -e "\n${BLUE}[${ORANGE}6${BLUE}]${LB} -u${BLUE}|${LB}--update-project: ${ORANGE}update ${P}lazy-anon ${ORANGE}via git${NC}"
}

# modes "$1"

while [ $# -gt 0 ]; do
  case $1 in

  -r | -torrc-reset | --torrc-reset)
    mode=10

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if ! [ -f $TORRC ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] There's no torrc to reset${NC}"
      exit 1
    fi

    chattr -i $TORRC >/dev/null 2>&1
    rm $TORRC >/dev/null 2>&1

    touch $TORRC >/dev/null 2>&1

    rtorc() {
cat << 'EOT' > $TORRC
# <--- By anonman for Torrc ---> #
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
}

    rtorc && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} Done, restart Tor to apply${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] Could not reset: ${ORANGE}$TORRC${NC}"
    exit 0

    shift
    break
    ;;

  -f | -load-torrc | --load-torrc)
    mode=11

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    file=$2

    if [ -z $file ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing a file${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${BLUE}--load-torrc ${YELLOW}<${NC}file${YELLOW}>${NC}"
      exit 1
    fi

    if ! [ -f $file ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] No such file: ${ORANGE}'$2'${NC}"
      exit 1
    fi

    if [ -f $TORRC ]; then
      chattr -i $TORRC >/dev/null 2>&1
      rm $TORRC >/dev/null 2>&1
      touch $TORRC >/dev/null 2>&1
      echo -e "\n# NOT TOUCH, THIS FILE IS CUSTOM LOAD #" >>$TORRC

      # Sorry but changing Tor ports without touching script may break the firewall logic #

      echo -e "\n# Do NOT change Tor ports, it may break script's firewall logic !! #\nTransPort $ADDR:$TRANS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr\nDNSPort $ADDR:$DNS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr\nSocksPort $ADDR:$SOCKS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr\nControlPort $ADDR:$CONTROL\nHTTPTunnelPort $ADDR:$HTTP" >>$TORRC
      cat "$file" >>$TORRC && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} custom Torrc applied${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] Could not apply: ${ORANGE}'$file'${NC}"
      chattr +i $TORRC >/dev/null 2>&1

      if id debian-tor >/dev/null 2>&1; then
        export TOR_USER="debian-tor"
      elif id tor >/dev/null 2>&1; then
        export TOR_USER="tor"
      elif id toranon >/dev/null 2>&1; then
        export TOR_USER="toranon"
      else
        echo -e "\n${RED}[${WHITE}X${RED}] No user for tor?${NC}"
        read -e -p $'\n\e[1;31m[\e[1;33mwarn\e[1;31m]\e[1;37m Please, enter a system user: \e[1;32m' TOR_USER $TOR_USER

        if id $TOR_USER >/dev/null 2>&1; then
          export TOR_USER=$TOR_USER
        else
          echo -e "\n${RED}[${LB}err${RED}] There is no lazy guy ${ORANGE}'$TOR_USER'${NC}"
          exit 1
        fi

      fi

      chown -R $TOR_USER:$TOR_USER $TORRC >/dev/null 2>&1

      if tor --verify-config >/dev/null 2>&1; then
        echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} Valid Torrc, you can restart Tor${NC}"
        exit 0
      else
        echo -e "\n${RED}[${WHITE}X${RED}] Invalid Torrc${NC}"
        exit 1
      fi

    else
      echo -e "\n${RED}[${WHITE}X${RED}] No such file: ${ORANGE}'$TORRC'${NC}"
      exit 1
    fi

    shift
    break
    ;;

  -p | -print | --print)

    mode=12
    object=$2

    if [[ -z $object ]]; then
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${P}--print ${NC}<${BLUE}object${NC}>"
      echo -e "\n${ORANGE}[${YELLOW}warn${ORANGE}]${NC} Objects are:"
      echo -e "\n${LB}firewall${NC}: ${BLUE}(${GREEN}$FWFILE${BLUE})${NC}"
      echo -e "\n${LB}torrc${NC}: ${BLUE}(${GREEN}$TORRC${BLUE})${NC}"
      echo -e "\n${LB}dns${NC}: ${BLUE}(${GREEN}$DNS${BLUE})${NC}"
      exit 1
    fi

    if [ "$object" == "firewall" ]; then

      if ! [ -f $FWFILE ]; then
        echo -e "\n${RED}[${WHITE}X${RED}] There's no firewall file${NC}"
        exit 1
      else
        cat $FWFILE
        exit 0
      fi

    elif [ "$object" == "torrc" ]; then

      if ! [ -f $TORRC ]; then
        echo -e "\n${RED}[${WHITE}X${RED}] There's no Torrc${NC}"
        exit 1
      else
        cat $TORRC
        exit 0
      fi

    elif [ "$object" == "dns" ]; then

      if ! [ -f $DNS ]; then
        echo -e "\n${RED}[${WHITE}X${RED}] There's no dns file${NC}"
        exit 1
      else
        cat $DNS
        exit 0
      fi
    else
      echo -e "\n${RED}[${WHITE}X${RED}] Invalid object: ${ORANGE}$object${NC}"
      exit 1
    fi

    shift
    break

    ;;

  -b | -load-bridges | --load-bridges)
    mode=7

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if ! [ -f $TORRC ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] There's not a Torrc${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} current: ${LB}$TORRC${NC}"
      exit 1
    fi

    file=$2
    kind=$3
    bin=$4

    chattr -i $TORRC >/dev/null 2>&1
    rm $TORRC >/dev/null 2>&1
    touch $TORRC >/dev/null 2>&1

    if [[ -z "$file" || -z $bin || -z $kind ]]; then
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${BLUE}--load-bridges ${YELLOW}<${NC}file${YELLOW}> ${YELLOW}<${NC}kind${YELLOW}> ${YELLOW}<${NC}bin${YELLOW}>${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} example: ${LB}$0 ${BLUE}--load-bridges ${P}bridges.txt ${P}obfs4 ${P}/usr/bin/obfs4proxy${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} correct format for bridges: ${NC}<${YELLOW}'bridge'${NC}> ${YELLOW}<${NC}type${YELLOW}> [${NC}IP${YELLOW}]${GREEN}:${YELLOW}[${NC}PORT${YELLOW}] [${NC}fingerprint${YELLOW}] [${NC}Key=value${YELLOW}]${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} example bridge: ${GREEN}bridge obfs4 212.227.255.73:8443 F54793EA577F90F679A9C0E787AB8431BDDABB41 cert=dOzgPNKdfo3SZIC2Sp3qtDX7wuo1KLzBe1KSzSAuK9CkySqF5/TnudjgHPub5sobpso4fw iat-mode=0${NC}"
	  exit 1

    elif ! [[ -f $file || -f $bin ]]; then
      echo -e "\n${RED}[${WHITE}X${RED}] No such bin or file${NC}"
      exit 1
    fi

    bridges=$(cat "$file")

    echo -e "\n# <--- Generated by anonman ---> #\n# Bridges Configuration #\n# NOT TOUCH, THIS FILE IS CUSTOM LOAD #\n# File locked by chattr +i, unlock: sudo chattr -i $TORRC #\nCookieAuthentication 0\nVirtualAddrNetworkIPv4 10.192.0.0/10\nAutomapHostsOnResolve 1\nMaxCircuitDirtiness 60\nAutomapHostsSuffixes .exit,.onion\nTransPort $ADDR:$TRANS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr\nDNSPort $ADDR:$DNS\nControlPort $ADDR:$CONTROL\nSocksPort $ADDR:$SOCKS IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr\nHTTPTunnelPort $ADDR:$HTTP\nClientTransportPlugin $kind exec $bin\n$bridges\nUseBridges 1\nClientUseIPv6 0\nClientPreferIPv6ORPORT 0\nClientRejectInternalAddresses 1\nHardwareAccel 1\nEnforceDistinctSubnets 1\nAvoidDiskWrites 1\n" | tee $TORRC >/dev/null 2>&1

    if tor --verify-config >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} Valid Torrc, you can restart Tor${NC}"
      chown -R $TOR_USER:$TOR_USER $TORRC
      chown -R $TOR_USER:$TOR_USER /var/lib/tor
      chattr +i $TORRC >/dev/null 2>&1
      exit 0
    else
      echo -e "\n${RED}[${WHITE}X${RED}] Invalid Torrc${NC}"
      exit 1
    fi

    shift
    break

    ;;

  -u | -update-project | --update-project)
    mode=11

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    cmd=git

    if ! (command -v $cmd >/dev/null 2>&1); then
      echo -e "\n${RED}[${WHITE}X${RED}] Install: ${ORANGE}'$cmd'${NC}"
      exit 1
    fi

    echo -e "\n${BLUE}[${ORANGE}warn${BLUE}]${GREEN} Updating project..${NC}"

    if git clone https://github.com/strxint/lazy-anon && cd lazy-anon && chmod +x * && ./lazyanon.sh; then
      echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} project updated${NC}"
      exit 0
    else
      echo -e "\n${RED}[${WHITE}X${RED}] Could not update project${NC}"
      exit 1
    fi

    shift
    break

    ;;

  -h | --help | -help | help)
    mode=12

    usage
    exit 1

    shift
    break

    ;;

  --* | -* | *)
    mode=6

    echo -e "\n${RED}[${WHITE}X${RED}] Invalid option: ${ORANGE}'$1'${NC}"
    echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} Try: '${LB}$0 ${BLUE}--help${ORANGE}'${NC}"
    exit 1

    shift
    break

    ;;

  esac
done

if [ -z $mode ]; then
  usage
  exit 1
fi
