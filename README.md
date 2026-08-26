
# ***Anon-scripts v4.0.0***

**-> Make Linux Truly anonymous with some user-friendly scripts <-**


## ***Features***

- Anonymous Protocols: Tor, i2pd.
- Secured configuration files: torrc, jupiter.nft.
- Modern firewall: nftables.
- MAC and interfaces script: saturn.
- Boot services for: systemd, runit, open-rc.
- User friendly scripts.
- Easy to mount and use.
- 100% bash code.
- Dependencies handled by: apt, pacman, dnf, yum, apk, zypper, emerge, xbps-install.
- Anonymous DNS script: neptune.
- Support for custom Torrc: uranus.

## ***Authors***

- [@strxint](https://www.github.com/strxint) (archnon@protonmail.com)


## ***Extra***

- Firewall is root only, same with services.
- Scripts will not support s6 for boot services.
- Get my personal stuff like .zshrc, .shrc, here: https://github.com/strxint/anon-config

## ***Installation***

Clone repo

```bash
  git clone https://github.com/strxint/anon-scripts
```

Get inside folder

```bash
  cd anon-scripts
```

Ensure root and exec permissions

```bash
  sudo chmod +x * || doas chmod +x *
```

Run any script as root

```bash
  sudo ./jupiter || doas ./jupiter
```


## ***Screenshots & Demo***
![App Screenshot](https://github.com/strxint/anon-scripts/blob/Screenshots/jupiter2.png)

## ***License***
[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/) 
* [GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/)


## ***Acknowledgements***

 - [Tor Project](https://www.torproject.org/)
 - [I2P - The Invisible Internet Protocol](https://i2p.net/en/)
 - [Bash - GNU Project](https://www.gnu.org/software/bash/)
 - [netfilter/iptables project](https://www.nftables.org/)
 - [curl](https://curl.se/)

![Logo](https://github.com/strxint/anon-scripts/blob/main/logo.png)
