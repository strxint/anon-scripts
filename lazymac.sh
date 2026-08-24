#!/bin/bash

################################################################################################################
#                                                                                                              #
# LAZY-MAC - Lazy Tool for managing things like MAC changing or system interfaces easly                        #
# CODED BY: archnon@protonmail.com                                                                             #
#                                                                                                              #
################################################################################################################

####################################################################
# Copyright (c) 2026 archnon@protonmail.com. All Rights Reserved.  #
####################################################################

##### colors #####

RED="\e[1;31m"

GREEN="\e[1;32m"

BLUE="\e[1;34m"

P="\e[1;35m"

YELLOW="\e[1;33m"

ORANGE="\e[38;5;214m"

WHITE="\e[1;37m"

LB="\e[36m"

NC="\e[0m"

if ! (command -v ip >/dev/null 2>&1 && command -v sudo >/dev/null 2>&1 && command -v macchanger >/dev/null 2>&1); then

  pkgs=(sudo macchanger iproute2)

  if [[ $(command -v apt) ]]; then
    if ! apt install -y ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v pacman) ]]; then
    if ! pacman -Sy --noconfirm --needed --overwrite "*" ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v dnf) ]]; then
    if ! dnf install -y --allowerasing ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v yum) ]]; then
    if ! yum install -y ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v xbps-install) ]]; then
    if ! xbps-install -Sy -f -y "*" ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v zypper) ]]; then
    if ! zypper install ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v apk) ]]; then
    if ! apk add --no-cache ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  elif [[ $(command -v emerge) ]]; then
    if ! emerge -v --oneshot --keep-going ${pkgs[@]}; then
      echo -e "\n${RED}[${WHITE}X${RED}] Could not install: ${ORANGE}'${pkgs[@]}'${NC}"
      exit 1
    fi
  else
    echo -e "\n${RED}[${WHITE}X${RED}] Unsuported package manager, install: ${ORANGE}'${pkgs[@]}'${NC}"
    exit 1
  fi
fi

##### Banner #####

echo -e "${BLUE} ████                                                                    "
echo -e "${BLUE}░░███                                                                    "
echo -e "${BLUE} ░███   ██████    █████████ █████ ████ █████████████    ██████    ██████ "
echo -e "${BLUE} ░███  ░░░░░███  ░█░░░░███ ░░███ ░███ ░░███░░███░░███  ░░░░░███  ███░░███"
echo -e "${BLUE} ░███   ███████  ░   ███░   ░███ ░███  ░███ ░███ ░███   ███████ ░███ ░░░ "
echo -e "${BLUE} ░███  ███░░███    ███░   █ ░███ ░███  ░███ ░███ ░███  ███░░███ ░███  ███"
echo -e "${BLUE} █████░░████████  █████████ ░░███████  █████░███ █████░░████████░░██████ "
echo -e "${BLUE}░░░░░  ░░░░░░░░  ░░░░░░░░░   ░░░░░███ ░░░░░ ░░░ ░░░░░  ░░░░░░░░  ░░░░░░  "
echo -e "${BLUE}                             ███ ░███                                    "
echo -e "${BLUE}                            ░░██████                                     "
echo -e "${BLUE}                             ░░░░░░                                      "

echo -e "\e[94m╔══════════════════════════════════╗
║ \e[92mlazy tool for interfaces and MAC\e[94m ║
╚══════════════════════════════════╝\e[0m"
echo -e "\e[97m[ ᴅᴇᴠᴇʟᴏᴘᴇᴅ ʙʏ: \e[95mᴀʀᴄʜɴᴏɴ@ᴘʀᴏᴛᴏɴᴍᴀɪʟ.ᴄᴏᴍ\e[97m ]\e[0m"

usage() {
  echo -e "\n${RED}[${YELLOW}warn${RED}]${ORANGE} usage: ${P}$0 ${NC}<${GREEN}COMMAND${NC}> ${NC}<${GREEN}OPTIONS${NC}>${NC}"
  echo -e "\n${BLUE}[${ORANGE}1${BLUE}] ${LB}-c${BLUE}|${LB}--change-mac: ${WHITE}change device MAC${NC}"
  echo -e "\n${BLUE}[${ORANGE}2${BLUE}] ${LB}-e${BLUE}|${LB}--enable-boot: ${WHITE}enable change MAC on boot${NC}"
  echo -e "\n${BLUE}[${ORANGE}3${BLUE}] ${LB}-d${BLUE}|${LB}--disable-boot: ${WHITE}disable ${GREEN}MAC changing on boot${NC}"
  echo -e "\n${BLUE}[${ORANGE}4${BLUE}] ${LB}-b${BLUE}|${LB}--in-background-change${NC} <${P}arg${NC}>: ${WHITE}change MAC of device in bg${NC}"
  echo -e "\n${BLUE}[${ORANGE}5${BLUE}] ${LB}-r${BLUE}|${LB}--restore-mac: ${WHITE}restore MAC of device${NC}"
  echo -e "\n${BLUE}[${ORANGE}6${BLUE}] ${LB}-l${BLUE}|${LB}--list-available-devices: ${WHITE}print a list of devices${NC}"
}

change() {
  ip link set $device down >/dev/null 2>&1

  macchanger -r -b $device >/dev/null 2>&1

  ip link set $device up >/dev/null 2>&1
}

restore() {
  ip link set $device down >/dev/null 2>&1

  macchanger -p $device >/dev/null 2>&1

  ip link set $device up >/dev/null 2>&1
}

createsv() {

  label=lazymac

  if [ ! -f /etc/systemd/system/$label.service ] && command -v systemctl >/dev/null 2>&1; then
    touch /etc/systemd/system/$label.service

    echo -e "\n[Unit]\nDescription=$label $device\n[Service]\nType=forking\nExecStart=$label -c $device\nRemainAfterExit=yes\nUser=root\n[Install]\nWantedBy=multi-user.target" >>/etc/systemd/system/$label.service

  fi

  if [ ! -f /etc/sv/$label/run ] && command -v runit >/dev/null 2>&1; then
    mkdir -p /etc/sv/$label/
    touch /etc/sv/$label/run

    echo -e "#!/bin/sh\nexec $label -c $device" >>/etc/sv/$label/run
    chmod +x /etc/sv/$label/run
  fi

  if [ ! -f /etc/init.d/$label ] && command -v rc-service >/dev/null 2>&1; then
    touch /etc/init.d/$label

    echo "#!/sbin/openrc-run\nname=$label $device\ncommand="$label"\ncommand_args="-c $device"\ncommand_background=true\npidfile="/run/${RC_SVCNAME}.pid"\ndepend() {\n    need net\n}" >>/etc/init.d/$label

    chmod +x /etc/init.d/$label >/dev/null 2>&1
  fi
}

enable() {

  if [ -f /etc/systemd/system/$label.service ] && command -v systemctl >/dev/null 2>&1; then

    if systemctl is-enabled $label >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You already got a $label${NC}"
      exit 1
    else
      systemctl enable $label >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You got a $label${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You didnt got a $label${NC}"
    fi
  fi

  if [ -f /etc/sv/$label/run ] && command -v runit >/dev/null 2>&1; then

    if [ -d /run/runit/service ]; then
      RSDIR=/run/runit/service
    elif [ -d /etc/service ]; then
      RSDIR=/etc/service
    elif [ -d /var/run/service ]; then
      RSDIR=/var/run/service
    fi

    if ls -l $RSDIR/$label/ >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You already got a $label${NC}"
      exit 1
    else
      ln -s /etc/sv/$label $RSDIR >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You got a $label${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You didnt got a $label${NC}"
    fi
  fi

  if [ -f /etc/init.d/$label ] && command -v rc-update >/dev/null 2>&1; then

    if sudo rc-update | grep -IE "$label" >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You already got a $label${NC}"
      exit 1
    else
      sudo rc-update add $label default >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} You got a $label${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] You didnt got a $label${NC}"
    fi
  fi
}

disable() {
  if [ -f /etc/systemd/system/$label.service ] && command -v systemctl >/dev/null 2>&1; then

    if ! systemctl is-enabled $label >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $label will not run${NC}"
      exit 0
    else
      systemctl disable $label >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $label deactivated${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] $label still active${NC}"
      exit 1
    fi
  fi

  if [ -f /etc/sv/$label/run ] && command -v runit >/dev/null 2>&1; then

    if [ -d /run/runit/service ]; then
      RSDIR=/run/runit/service

    elif [ -d /etc/service ]; then
      RSDIR=/etc/service

    elif [ -d /var/run/service ]; then
      RSDIR=/var/run/service
    fi

    if ! ls -l $RSDIR/$label/ >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $label will not run${NC}"
      exit 0
    else
      rm -rf $RSDIR/$label >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $label deactivated${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] $label still active${NC}"
      exit 1
    fi
  fi

  if [ -f /etc/init.d/$label ] && command -v rc-service >/dev/null 2>&1; then

    if ! rc-update | grep -IE "$label" >/dev/null 2>&1; then
      echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $label will not run${NC}"
      exit 0
    else
      rc-update del $label default >/dev/null 2>&1 && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $label deactivated${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] $label still active${NC}"
      exit 1
    fi
  fi
}

dlist() {
  if pgrep -x mactd >/dev/null 2>&1; then
    echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} Active Background PID: ${NC}"
    pgrep -a mactd
    echo -e "\n${RED}[${YELLOW}warn${RED}] Kill: ${RED}pkill -9 mactd${NC}"
  fi
}

while [ $# -gt 0 ]; do
  case $1 in

  -c | -change-mac | --change-mac)
    mode=1
    device=$2

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if [ -z $device ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing a lazy device${NC}"
      exit 1
    fi

    if ! macchanger -s "$device" >/dev/null 2>&1; then
      echo -e "\n${RED}[${WHITE}X${RED}] No such device: ${ORANGE}'$device'${NC}"
      exit 1
    fi

    change && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $(macchanger -s $device | grep Current)${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] no new lazy MAC${NC}"
    exit 1

    shift
    break

    ;;

  -e | -enable-boot | --enable-boot)
    mode=2
    device=$2

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if [ -z $device ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing a lazy device${NC}"
      exit 1
    fi

    if ! macchanger -s $device >/dev/null 2>&1; then
      echo -e "\n${RED}[${WHITE}X${RED}] No such device: ${ORANGE}'$device'${NC}"
      exit 1
    fi

    createsv

    enable

    exit 0

    shift
    break

    ;;

  -d | -disable-boot | --disable-boot)
    mode=3
    device=$3

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    createsv

    disable

    exit 0

    shift
    break

    ;;

  -b | -in-background-change | --in-background-change)
    mode=4
    i=$2
    device=$3

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if [ -z $i ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing time in seconds${NC}"
      exit 1
    fi

    if [ -z $device ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing lazy device${NC}"
      exit 1
    fi

    if ! macchanger -s $device >/dev/null 2>&1; then
      echo -e "\n${RED}[${WHITE}X${RED}] No such device: ${ORANGE}'$device'${NC}"
      exit 1
    fi

    if ! command -v mactd >>/dev/null 2>&1; then
      echo -e "\n${RED}[${WHITE}X${RED}] Missing lazy background script: ${ORANGE}'mactd'${NC}"
      exit 1
    else
      mactd $i $device && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} lazy background${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] lazy background${NC}"
      dlist
      exit 0
    fi

    shift
    break

    ;;

  -r | -restore-mac | --restore-mac)
    mode=5
    device=$2

    if [ $EUID -ne 0 ]; then
      echo -e "\n${RED}[${WHITE}X${RED}] Run as root${NC}"
      exit 1
    fi

    if [ -z $device ]; then
      usage
      echo -e "\n${RED}[${WHITE}X${RED}] Missing lazy device${NC}"
      exit 1
    fi

    if ! macchanger -s "$device" >/dev/null 2>&1; then
      echo -e "\n${RED}[${WHITE}X${RED}] No such device: ${ORANGE}'$device'${NC}"
      exit 1
    fi

    restore && echo -e "\n${BLUE}[${LB}OK${BLUE}]${P} $(macchanger -s $device | grep Current)${NC}" || echo -e "\n${RED}[${WHITE}X${RED}] restore lazy MAC${NC}"
    exit 0

    shift
    break

    ;;

  -l | -list-available-devices | --list-available-devices)
    mode=6

    if ! ip link >/dev/null 2>&1; then
      echo -e "\n${RED}[${WHITE}X${RED}] lazy devices${NC}"
      exit 1
    else
      echo -n -e "\n"
      ip link
      exit 0
    fi

    shift
    break

    ;;

  --* | -* | *)
    mode=6

    usage
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
