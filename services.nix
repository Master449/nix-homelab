{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 8096 8082 ];
  
  services.httpd.enable = true;
  services.httpd.adminAddr = "admin@example.org";
  services.httpd.enablePHP = true;
  
  systemd.tmpfiles.rules = [
    "d /var/www/mysite.com"
    "f /var/www/mysite.com/index.php - - - - <?php phpinfo();"
  ];

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  
  services.jellyfin = {
    enable = true;
  };

}
