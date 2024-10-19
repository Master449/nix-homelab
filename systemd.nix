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
  systemd.services.backup = {
    description = "Backs up the main drive to the backup with rsync, preserving permissions and only updating if needed.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.rsync}/bin/rsync -aq /mnt/WD1/* /mnt/WD2/ --delete'";
    };
    restartIfChanged = false;
  };
 
  # Define the timer for the backup service
  systemd.timers.backup-timer = {
    description = "Run the Samba Backup service daily at 2AM";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "02:00:00";
      Persistent = true;
      Unit = "samba-backup.service";
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
        "0 0 * * *      root    /home/david/nix-homelab/scripts/daily-maintenance.sh"
        "0 2 * * 0      root    /home/david/nix-homelab/scripts/weekly-maintenance.sh"
        "0 5 1 * *      root    /home/david/nix-homelab/scripts/monthly-maintenance.sh"
    ];
  };
}
