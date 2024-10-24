{ config, pkgs, ... }:
{

  # ---------------- Packages --------------------
  environment.systemPackages = with pkgs; [
    rsync
    smartmontools  # SMART tests and Info
  ];

  # ---------------- Packages --------------------

  # ---------------- Samba Users --------------------
  users.users = {
    test = {
      isNormalUser = true;
      description = "SMB Test Account";
      extraGroups = [ "samba" ];
    };
    media = {
      isNormalUser = true;
      description = "Media Vault";
      extraGroups = [ "samba" ];

    };
    time-machine = {
      isSystemUser = true;
      group = "time-machine";
      home = "/mnt/WD1/time-machine";
    };

  };
   
   users.groups.time-machine = {};

  # ---------------- Samba Config --------------------
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      security = user
      inherit permission = yes
    '';
    shares = {
      #TimeMachine = {
      #  path = "/mnt/WD1/time-machine";
      #  "valid users" = "time-machine";
      #  public = "no";
      #  writeable = "yes";
      #  "fruit:aapl" = "yes";
      #  "fruit:time machine" = "yes";
      #  "vfs objects" = "catia fruit streams_xattr";
      #};
      media = {
        path = "/mnt/WD1/Media";
	"read only" = "no";
        "guest ok" = "no";
        "create mask" = "0777";
        "directory mask" = "0777";
	"valid users" = "jellyfin,@admin,@samba";
	"writeable" = "yes";
      };
      david = {
        path = "/mnt/WD1/David";
	"read only" = "no";
        "guest ok" = "no";
        "create mask" = "0777";
        "directory mask" = "0777";
	"valid users" = "david,@admin,@samba";
	"writeable" = "yes";
      };
      
    };
  };
}
