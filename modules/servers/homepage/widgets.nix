[
  {
    resources = {
      cpu = true;
      cputemp = true;
      units = "metric";
      disk = "/";
      memory = true;
    };
  }
  {
    search = {
      provider = [
        "brave"
        "bing"
        "google"
      ];
      target = "_blank";
      showSearchSuggestions = true;
    };
  }
  {
    openweathermap = {
      label = "Celaya";
      latitude = 20.5167;
      longitude = -100.8167;
      units = "metric";
      provider = "openweathermap";
      cache = 5;
      format = {
        maximumFractionDigits = 1;
      };
    };
  }
]
