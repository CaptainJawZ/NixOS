{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.scripts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Whether to enable this script";
          install = lib.mkEnableOption "Whether to install the script package";
          service = lib.mkEnableOption "Whether to enable the script service";
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the script.";
          };
          timer = lib.mkOption {
            type = lib.types.str;
            default = "*:0";
            description = "Systemd timer schedule.";
          };
          description = lib.mkOption {
            type = lib.types.str;
            description = "Description of the service.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            description = "Package containing the executable script.";
          };
        };
      }
    );
    default = { };
    description = "Configuration for multiple scripts.";
  };

  config = lib.mkIf (lib.any (s: s.enable) (lib.attrValues config.my.scripts)) {
    users.users.jawz.packages =
      config.my.scripts
      |> lib.mapAttrsToList (_name: script: lib.optional (script.enable && script.install) script.package)
      |> lib.flatten;

    systemd.user.services =
      config.my.scripts
      |> lib.mapAttrs' (
        _name: script:
        lib.nameValuePair "${script.name}" (
          lib.mkIf (script.enable && script.service) {
            restartIfChanged = true;
            inherit (script) description;
            wantedBy = [ "default.target" ];
            path = [
              pkgs.nix
              script.package
            ];
            serviceConfig = {
              Restart = "on-failure";
              RestartSec = 30;
              ExecStart = "${script.package}/bin/${script.name}";
            };
          }
        )
      );

    systemd.user.timers =
      config.my.scripts
      |> lib.mapAttrs' (
        _name: script:
        lib.nameValuePair "${script.name}" (
          lib.mkIf (script.enable && script.service) {
            enable = true;
            inherit (script) description;
            wantedBy = [ "timers.target" ];
            timerConfig = {
              OnCalendar = script.timer;
            };
          }
        )
      );
  };
}
