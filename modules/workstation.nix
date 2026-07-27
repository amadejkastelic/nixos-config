{ config, lib, ... }:
let
  inherit (lib) mkOption types;

  positiveNumber = types.addCheck types.number (value: value > 0);

  modeOptions = {
    output = mkOption {
      type = types.str;
    };

    width = mkOption {
      type = types.ints.positive;
    };

    height = mkOption {
      type = types.ints.positive;
    };

    refreshRate = mkOption {
      type = types.ints.positive;
    };

    scale = mkOption {
      type = positiveNumber;
    };
  };

  displayType = types.submodule {
    options = modeOptions // {
      position = mkOption {
        type = types.str;
      };
    };
  };

  gamingType = types.submodule {
    options = modeOptions;
  };
in
{
  options.workstation = {
    displays = mkOption {
      type = types.listOf displayType;
      default = [ ];
    };

    gaming = mkOption {
      type = gamingType;
    };
  };

  config.assertions = [
    {
      assertion = config.workstation.displays != [ ];
      message = "Graphical hosts must configure at least one workstation display.";
    }
    {
      assertion = builtins.any (
        display: display.output == config.workstation.gaming.output
      ) config.workstation.displays;
      message = "The workstation gaming output must reference a configured display.";
    }
  ];
}
