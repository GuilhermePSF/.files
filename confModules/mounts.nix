{ ... }:

{
  fileSystems."/mnt/PopOSPartition" = {
    device = "/dev/disk/by-uuid/4674f222-87f4-46a1-8b0e-18796c5faccf";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/gui/popOSHome" = {
    device = "/mnt/PopOSPartition/home/gui";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/PopOSPartition" ];
  };
}
