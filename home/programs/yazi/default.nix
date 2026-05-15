{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableFishIntegration = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "modified";
        sort_reverse = true;
        sort_dir_first = true;
      };
      preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
      };
    };
  };
}
