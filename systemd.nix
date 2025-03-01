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
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.rsync}/bin/rsync -aq /mnt/EX1/* /mnt/EX2/ --delete'";
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
      Unit = "backup.service";
    };
  };

  # ---------------- Docker Backup unit --------------------
  systemd.services.docker-backup = {
    description = "Backs up docker containers to the backup with rsync, preserving permissions and only updating if needed.";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.rsync}/bin/rsync -aq /home/david/docker/* /mnt/EX1/docker-backup --delete'";
    };
    restartIfChanged = false;
  };
 
  # Define the timer for the backup service
  systemd.timers.docker-backup-timer = {
    description = "Run the Docker Backup service daily at 3AM";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "03:00:00";
      Persistent = true;
      Unit = "docker-backup.service";
    };
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
        "0 0 * * *      root    /home/david/nix-homelab/scripts/daily-maintenance.sh"
        "0 2 * * 0      root    /home/david/nix-homelab/scripts/weekly-maintenance.sh"
        "0 5 1 * *      root    /home/david/nix-homelab/scripts/monthly-maintenance.sh"
        "0 0 * * 0      root    /home/david/nix-homelab/scripts/automatic-backups.sh /mnt/EX1/syncthing/st-sync/syncthing/ /mnt/EX1/Media/Backups/syncthing-backups"
        "0 0 1 * *      root    /home/david/nix-homelab/scripts/automatic-backups.sh /home/david/docker/ /mnt/EX1/Media/Backups/docker-backups"
    ];
  };
}
