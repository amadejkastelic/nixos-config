{
  lib,
  pkgs,
  ...
}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-alsa-config.conf" ''
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
                audio.channels = 2
                audio.rate = 44100
                api.alsa.period-size = 128
                api.alsa.headroom = 0
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
                audio.channels = 2
                audio.rate = 44100
                api.alsa.period-size = 128
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
                audio.rate = 48000
                audio.allowed-rates = "44100,48000"
                api.alsa.period-size = 128
              }
            }
          }
        ]
      '')
    ];
  };

  services.pulseaudio.enable = lib.mkForce false;
}
