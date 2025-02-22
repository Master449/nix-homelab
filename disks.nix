{ config, lib, pkgs, modulesPath, ... }:
{
  # 4TB Western Digital Red
  fileSystems."/mnt/WD1" = 
    { device = "/dev/disk/by-uuid/5dab6e68-c75f-4d09-9472-6ffb8df4ee93";
      fsType = "ext4";
    };
  
  # 4TB Western Digital Red
  fileSystems."/mnt/WD2" = 
    { device = "/dev/disk/by-uuid/f64b104f-9553-4081-a48a-30c3af6b815a";
      fsType = "ext4";
    };

  # 4TB Seagate
  fileSystems."/mnt/SG1" = 
    { device = "/dev/disk/by-uuid/18c39832-50ed-4784-8ea4-f831e6496e5d";
      fsType = "ext4";
    };
  
  # 14TB Seagate Exos
  fileSystems."/mnt/EX1" = 
    { device = "/dev/disk/by-uuid/a72c24b9-61c8-4525-b986-8b542f55dec0";
      fsType = "ext4";
    };
   
  # 14TB Seagate Exos
  fileSystems."/mnt/EX2" = 
    { device = "/dev/disk/by-uuid/26335814-0279-41ff-8945-5c08a186b725";
      fsType = "ext4";
    };
}
