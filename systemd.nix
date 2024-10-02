{ config, pkgs, ... }: 
{
  
  # ---------------- Glances --------------------
  systemd.services.flances-server = {
    description = "runs the glances api with no web ui";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.glances}/bin/glances -w --disable-webui'";
    };
    restartIfChanged = false;
  };

  # ---------------- Reolink Aggregator API --------------------
  systemd.services.express-server = {
    description = "runs the reolink API aggregator express server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '/home/david/reolink-aggregator/server.js'";
    };
    restartIfChanged = false;
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
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.smartmontools}/bin/smartctl -t short /dev/sda && ${pkgs.smartmontools}/bin/smartctl -t short /dev/sdb'";
    };
    restartIfChanged = false;
    serviceConfig.RemainAfterExit = true;
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
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.smartmontools}/bin/smartctl -a /dev/sda > /home/david/sda_log && ${pkgs.smartmontools}/bin/smartctl -a /dev/sdb > /home/david/sdb_log'";
    };
    restartIfChanged = false;
    serviceConfig.RemainAfterExit = true;
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
