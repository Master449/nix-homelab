{ config, lib, pkgs, modulesPath, ... }:
{
  
  fileSystems."/mnt/WD1" = 
    { device = "/dev/disk/by-uuid/5dab6e68-c75f-4d09-9472-6ffb8df4ee93";
      fsType = "ext4";
    };
  
  fileSystems."/mnt/WD2" = 
    { device = "/dev/disk/by-uuid/f64b104f-9553-4081-a48a-30c3af6b815a";
      fsType = "ext4";
    };
}
