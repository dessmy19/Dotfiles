# My personal setup for Artix Linux running **dwl**. Includes a one-shot install script.

## Install

Boot the Artix Runit live ISO, then:

```bash
git clone https://github.com/dessmy19/Dotfiles && cd Dotfiles && sudo bash setup
```

This wipes the target disk.

## VPN

Drop your ProtonVPN WireGuard config in place, then toggle it with `scripts/vpn`:

```bash
sudo cp ~/Downloads/VPN-*.conf /etc/wireguard/vpn.conf
sudo chmod 600 /etc/wireguard/vpn.conf
```
