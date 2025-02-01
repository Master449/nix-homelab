{ config, pkgs, ... }:
{
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  
  networking.firewall.allowedTCPPorts = [ 
    22    # SSH
    80    # HTTP
    443   # HTTPs
    139   # Samba
    2375  # Docker Host
    3000  # Homepage
    3001  # SilverBullet
    3031  # Testing
    4000  # Speedtest Tracker
    5000  # NUT (UPS) Server
    5050  #Jellyplist
    5800  # Filebot
    6001  # PeaNUT Dashboard
    7000  # Uptime Kuma
    8100  # BlueMap Minecraft
    8384  # Syncthing
    8090  # Beszel
    8096  # Jellyfin
    9091  # Transmission
    25565 # Minecraft
    45876 # Geszel Agent
    61208 # Glances
  ];
  
  networking.firewall.allowedUDPPorts = [ 
    137   # Samba
    9000  # Outgoing Port
  ];
#  networking.firewall.interfaces."wg0-mullvad".allowedTCPPortRanges = [ { from = 800; to = 25000; } ];
#  networking.firewall.interfaces."wg0-mullvad".allowedUDPPortRanges = [ { from = 800; to = 25000; } ];
}
