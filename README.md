# NixOS Homelab

Current runs a samba server, and some custom systemd units to take care of backups and SMART tests.

Just some stuff I need to remember:

Users need a nixos user account
Remember to change their password with smbpasswd -a (no -a if they exist already)

# Plans

ToDo:
- Setup Alert System for drives (SMART testing?)
- Setup Jellyfin container

# Completed

Done:
- Setup git repo
- Move /etc/nixos to somewhere where sudo isnt needed
- Setup Tailscale
