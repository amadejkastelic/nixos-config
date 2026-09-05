{
  services.hyprsunset = {
    enable = true;

    settings = {
      max-gamma = 150;

      profile = [
        {
          time = "7:30";
          identity = true;
        }
        {
          time = "20:30";
          temperature = 3000;
        }
      ];
    };
  };
}
