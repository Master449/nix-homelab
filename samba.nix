{ config, pkgs, ... }:
{

  # ---------------- Packages --------------------
  environment.systemPackages = with pkgs; [
    rsync
    smartmontools  # SMART tests and Info
  ];

  # ---------------- Packages --------------------
  networking.firewall.allowedTCPPorts = [ 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

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
      TimeMachine = {
        path = "/mnt/WD1/time-machine";
        "valid users" = "time-machine";
        public = "no";
        writeable = "yes";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        #"fruit:model" = "N88AP";
        "vfs objects" = "catia fruit streams_xattr";
      };
      media = {
        path = "/mnt/WD1/Media";
	"read only" = "no";
        "guest ok" = "no";
        "create mask" = "0777";
        "directory mask" = "0777";
	"valid users" = "media,jellyfin,@samba";
	"writeable" = "yes";
      };
      david = {
        path = "/mnt/WD1/David";
	"read only" = "no";
        "guest ok" = "no";
        "create mask" = "0777";
        "directory mask" = "0777";
	"valid users" = "david,@samba";
	"writeable" = "yes";
      };
      
    };
  };

  # ---------------- Samba Backup unit --------------------
  systemd.services.samba-backup = {
    description = "Backs up the main drive to the backup with rsync, preserving permissions and only updating if needed.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.rsync}/bin/rsync -aq /mnt/WD1/* /mnt/WD2/ --delete'";
    };
    restartIfChanged = false;
  };
 
  # Define the timer for the copy service
  systemd.timers.samba-backup-timer = {
    description = "Run the Samba Backup service daily at 2AM";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:00:00";
      Persistent = true;
      Unit = "samba-backup.service";
    };
  };

  # ---------------- SMART Test unit --------------------
  systemd.services.smart-short-test = {
    description = "Run a short SMART test on the drives.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.smartmontools}/bin/smartctl -t short /dev/sdb && ${pkgs.smartmontools}/bin/smartctl -t short /dev/sdc'";
    };
    restartIfChanged = false;
  };

  systemd.timers.smart-short-timer = {
    description = "Run SMART Short tests once a week";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon *-*-* 03:00:00";
      Persistent = true;
      Unit = "smart-short-test.service";
    };
  };
  
  # ---------------- Log SMART Test unit --------------------
  systemd.services.log-smart-short-test = {
    description = "Log the SMART tests";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.smartmontools}/bin/smartctl -a /dev/sdb > /home/david/sdb_log && ${pkgs.smartmontools}/bin/smartctl -a /dev/sdc > /home/david/sdc_log'";
    };
  };

  systemd.timers.log-smart-short-timer = {
    description = "Run SMART Short tests once a week";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon *-*-* 04:00:00";
      Persistent = true;
      Unit = "log-smart-short-test.service";
    };
  };
}
