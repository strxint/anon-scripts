#!/bin/bash

################################################################################################################
#                                                                                                              #
# ANON-DNS: Simple Tool for making DNS Anonymous via Firewall & Tor daemon (can resolve .onion).               #
# CODED BY: archnon@protonmail.com                                                                             #
#                                                                                                              #
################################################################################################################
####################################################################
# Copyright (c) 2026 archnon@protonmail.com. All Rights Reserved.  #
####################################################################

##### Colors #####

RED="\e[1;31m"

GREEN="\e[1;32m"

BLUE="\e[1;34m"

P="\e[1;35m"

YELLOW="\e[1;33m"

ORANGE="\e[38;5;214m"

WHITE="\e[1;37m"

LB="\e[36m"

NC="\e[0m"

##### Default Socks5 Address #####
ADDR=127.0.0.1
PORT=9150

usage() {
  echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${P}$0 ${NC}<${GREEN}COMMAND${NC}> <${LB}OPTIONS${NC}>${NC}"
  echo -e "\n${BLUE}[${YELLOW}1${BLUE}]${ORANGE} -u${BLUE}|${ORANGE}--url ${NC}<${P}url${NC}>${NC}"
  echo -e "\n${BLUE}[${YELLOW}2${BLUE}]${ORANGE} -a${BLUE}|${ORANGE}--resolv-with-address ${NC}<${P}addr${NC}> <${P}url${NC}>${NC}"
  echo -e "\n${BLUE}[${YELLOW}3${BLUE}]${ORANGE} -s${BLUE}|${ORANGE}--set-dns-address ${NC}<${P}addr${NC}>${NC}"
}

need=e2fsprogs

if ! command -v chattr >/dev/null 2>&1; then
  if [[ $(command -v apt) ]]; then
    if ! apt install -y $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v pacman) ]]; then
    if ! pacman -Sy --noconfirm --needed --overwrite "*" $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v dnf) ]]; then
    if ! dnf install -y --allowerasing $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v yum) ]]; then
    if ! yum install -y $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v xbps-install) ]]; then
    if ! xbps-install -Sy -f -y "*" $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v zypper) ]]; then
    if ! zypper install $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v apk) ]]; then
    if ! apk add --no-cache $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  elif [[ $(command -v emerge) ]]; then
    if ! emerge -v --oneshot --keep-going $logos; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}$need${NC}"
      exit 1
    fi
  else
    echo -e "\n${RED}[${WHITE}X${RED}] Unsuported package manager, install: ${ORANGE}'$need'${NC}"
    exit 1
  fi
fi

echo -e "${WHITE}   █████████                                 ${P} ██████████   ██████   █████  █████████ "
echo -e "${WHITE}  ███░░░░░███                                ${P}░░███░░░░███ ░░██████ ░░███  ███░░░░░███"
echo -e "${WHITE} ░███    ░███  ████████    ██████  ████████  ${P} ░███   ░░███ ░███░███ ░███ ░███    ░░░ "
echo -e "${WHITE} ░███████████ ░░███░░███  ███░░███░░███░░███ ${P} ░███    ░███ ░███░░███░███ ░░█████████ "
echo -e "${WHITE} ░███░░░░░███  ░███ ░███ ░███ ░███ ░███ ░███ ${P} ░███    ░███ ░███ ░░██████  ░░░░░░░░███"
echo -e "${WHITE} ░███    ░███  ░███ ░███ ░███ ░███ ░███ ░███ ${P} ░███    ███  ░███  ░░█████  ███    ░███"
echo -e "${WHITE} █████   █████ ████ █████░░██████  ████ █████${P}██████████   █████  ░░█████░░█████████  "
echo -e "${WHITE} ░░░░░   ░░░░░ ░░░░ ░░░░░  ░░░░░░  ░░░░ ░░░░░${P}░░░░░░░░░░   ░░░░░    ░░░░░  ░░░░░░░░░  "
echo -e "${WHITE}                                             ${P}                                        "
echo -e "${WHITE}                                             ${P}                                        "
echo -e "${WHITE}                                             ${P}                                        "

echo -e "\e[95m╔════════════════════════╗
║ \e[97mTool for anonymous dns\e[95m ║
╚════════════════════════╝\e[0m"
echo -e "\e[97mᴅᴇᴠᴇʟᴏᴘᴇᴅ ʙʏ: \e[95mᴀʀᴄʜɴᴏɴ@ᴘʀᴏᴛᴏɴᴍᴀɪʟ.ᴄᴏᴍ\e[0m"

while [ $# -gt 0 ]; do
  case $1 in
  -u | -url | --url)
    mode=1
    url=$2

    if [ -z $url ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing an url${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${P}--url ${YELLOW}<${NC}url${YELLOW}>${NC}"
      exit 1
    else
      SOCKS5=$ADDR:$PORT
      echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} Default Address: ${WHITE}$ADDR${GREEN}:${WHITE}$PORT${NC}"
      curl -s --socks5-hostname $SOCKS5 "$url" && echo -e "\n${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] Could not resolv: ${ORANGE}'$url'${NC}"
      exit 0
    fi

    shift
    break

    ;;

  -a | -resolv-with-address | --resolv-with-address)
    mode=2
    NEW_ADDR=$2
    url=$3

    if [[ -z $NEW_ADDR || -z $url ]]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing url or address${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${P}--resolv-with-address ${NC}<${BLUE}addr${NC}> <${BLUE}url${NC}>${NC}"
      exit 1
    else
      SOCKS5="$NEW_ADDR"
      curl --socks5-hostname $SOCKS5 "$url" && echo -e "\n${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] Could not resolv: ${ORANGE}'$url'${NC}"
      exit 0
    fi

    shift
    break

    ;;

  -s | -set-dns-address | --set-dns-address)
    mode=3
    addr=$2

    if ! [ -f /etc/resolv.conf ]; then
      touch /etc/resolv.conf >/dev/null 2>&1
    fi

    if [ -z $addr ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing the address to set${NC}"
      echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${LB}$0 ${BLUE}--set-dns-address ${YELLOW}<${BLUE}addr${YELLOW}>${NC}"
      exit 1
    else

      chattr -i /etc/resolv.conf >/dev/null 2>&1
      rm /etc/resolv.conf >/dev/null 2>&1
      touch /etc/resolv.conf >/dev/null 2>&1

      echo "nameserver $addr" | tee /etc/resolv.conf >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OKAY${BLUE}]${P} New dns address: ${GREEN}$addr${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] Could not set dns address${NC}"
      exit 0

    fi

    shift
    break
    ;;

  -h | --help | -help | help)
    mode=4

    usage
    exit 1

    shift
    break

    ;;

  --* | -* | *)
    mode=4

    echo -e "\n${RED}[${WHITE}X${RED}] Invalid param: ${ORANGE}'$1'${NC}"
    echo -e "\n${RED}[${YELLOW}warn${RED}] Try: ${LB}'$0 --help'${NC}"
    exit 1

    shift
    break

    ;;

  esac
done

if [ -z "$mode" ]; then
  usage
  exit 1
fi
