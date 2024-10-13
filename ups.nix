{ config, pkgs, ... }:
{
  # Configuration file for CyberPower GX1500U
  power.ups = {
    
    enable = true;
    
    # This specific UPS
    ups."GX1500U" = {
      driver = "usbhid-ups";
      port = "auto";
    };

    # User to manage
    users.upsmon = {
      passwordFile = "/home/david/upsmon.password";
      upsmon = "primary";
    };

    upsmon.monitor."GX1500U".user = "upsmon";

    # NUT Server for client devices
    #upsd = {
    #  enable = true;
    #  listen = [{
    #    address = "";
    #    port = ;
    #  }];
    #};
  };
}
