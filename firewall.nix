{ config, pkgs, ... }:
{
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  
  networking.firewall.allowedTCPPorts = [ 
    22    # SSH
    80    # HTTP
    445   # HTTPs
    139   # Samba
    3000  # Homepage
  ];
  
  networking.firewall.allowedUDPPorts = [ 
    137   # Samba
    9000  # Outgoing Port
  ];
#  networking.firewall.interfaces."wg0-mullvad".allowedTCPPortRanges = [ { from = 800; to = 25000; } ];
#  networking.firewall.interfaces."wg0-mullvad".allowedUDPPortRanges = [ { from = 800; to = 25000; } ];
}
