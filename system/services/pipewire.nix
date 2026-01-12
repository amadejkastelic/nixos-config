{
  lib,
  pkgs,
  ...
}:
let
  rate = 48000;
  quantum = 64;
  quantumStr = "${toString quantum}/${toString rate}";
in
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = rate;
        "default.clock.quantum" = quantum / 2;
        "default.clock.min-quantum" = quantum / 4;
        "default.clock.max-quantum" = quantum * 4;
      };
      "context.modules" = [
        { name = "libpipewire-module-rt"; }
      ];
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = quantumStr;
        "pulse.default.req" = quantumStr;
        "pulse.min.quantum" = quantumStr;
      };
      "stream.properties" = {
        "node.latency" = quantumStr;
        "resample.quality" = 1;
      };
    };

    configPackages = [
      (pkgs.writeTextDir "share/pipewire/client.conf.d/10-cs2-client.conf" ''
        stream.rules = [
          {
            matches = [
              { application.name = "SDL Application" }
              { media.role = "Game" }
            ]
            actions = {
              update-props = {
                node.name = "Counter Strike 2"
                node.nick = "Counter Strike 2"
                node.force-quantum = ${builtins.toString quantum}
                node.rate = 1/${builtins.toString rate}
              }
            }
          }
        ]
      '')
    ];

    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-low-latency.conf" ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "~alsa_output.*"
              }
              {
                node.name = "~alsa_input.*"
              }
            ]
            actions = {
              update-props = {
                session.suspend-timeout-seconds = 0
                node.pause-on-idle = false
              }
            }
          }
          {
            matches = [
              {
                device.name = "~alsa_card.usb-GuangZhou_FiiO_Electronics_Co.*"
              }
            ]
            actions = {
              update-props = {
                device.profile = "pro-audio"
                audio.channels = 2
                audio.rate = ${toString rate}
                audio.allowed-rates = "44100,${toString rate},96000"
                api.alsa.period-size = ${toString quantum}
                api.alsa.period-num = 3
                api.alsa.headroom = 0
                api.alsa.disable-batch = true
              }
            }
          }
          {
            matches = [
              {
                device.name = "alsa_card.usb-FiiO_K3-00"
              }
            ]
            actions = {
              update-props = {
                node.nick = "FiioK3"
                device.profile = "pro-audio"
                audio.channels = 2
                audio.rate = ${toString rate}
                audio.allowed-rates = "44100,${toString rate},96000"
                api.alsa.period-size = ${toString quantum}
                api.alsa.period-num = 3
                api.alsa.headroom = 0
                api.alsa.disable-batch = true
              }
            }
          }
          {
            matches = [
              {
                device.name = "alsa_card.usb-Blue_Microphones_Yeti_Stereo_Microphone_FST_2018_12_11_57223-00"
              }
            ]
            actions = {
              update-props = {
                node.nick = "YetiPro"
                audio.rate = ${toString rate}
                audio.allowed-rates = "44100,${toString rate}"
                api.alsa.period-size = ${toString (quantum * 2)}
              }
            }
          }
        ]
      '')
    ];
  };

  security.rtkit.enable = true;

  services.pulseaudio.enable = lib.mkForce false;
}
