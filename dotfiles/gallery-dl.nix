{
  extractor = {
    skip = "abort:5";
    cookies = [
      "firefox"
      # "/home/jawz/.librewolf/jjwvqged.default"
      "gnomekeyring"
    ];
    user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:132.0) Gecko/20100101 Firefox/132.0";
    retries = 10;
    sleep-request = 0;
    directlink = {
      filename = "{filename}.{extension}";
      directory = [ ];
    };
    bluesky = {
      reposts = false;
      videos = true;
      directory = [ "{author['handle']}" ];
      include = [ "media" ];
    };
    twitter = {
      skip = "abort:1";
      retweets = false;
      videos = "ytdl";
      logout = true;
      include = [ "media" ];
      directory = [ "{user[name]}" ];
    };
    flickr = {
      size-max = "Original";
      directory = [
        "{category}"
        "{owner[username]}"
      ];
    };
    pinterest.directory = [
      "{board[owner][username]}"
      "{board[name]}"
    ];
    instagram = {
      sleep = "45-60";
      sleep-request = "45-60";
      parent-directory = true;
      directory = [ "{username}" ];
      previews = true;
      highlights = {
        reverse = true;
        directory = [ "{username}" ];
      };
      stories = {
        reverse = true;
        directory = [ "{username}" ];
      };
      tagged.directory = [
        "{username}"
        "tagged"
        "{tagged_username}"
      ];
    };
    tumblr = {
      external = true;
      inline = true;
      posts = "all";
      reblogs = false;
      parent-directory = true;
      directory = [ "{blog_name}" ];
    };
    deviantart = {
      include = "gallery,scraps";
      flat = true;
      original = true;
      mature = true;
      auto-watch = true;
      auto-unwatch = true;
      directory = [ "{username}" ];
    };
    patreon = {
      filename = "{filename}.{num}.{extension}";
      browser = "firefox";
      directory = [
        "(Patreon) {creator[vanity]}"
        "({date:%Y%m%d}) {title} ({id})"
      ];
    };
    blogger = {
      filename = "{filename} - {num}.{extension}";
      directory = [
        "{blog[name]}"
        "{post[author]}"
        "{post[title]} - [{post[id]}]"
      ];
    };
    artstation = {
      external = true;
      directory = [ "{userinfo[username]}" ];
    };
    gfycat.format = "webm";
    reddit = {
      parent-directory = true;
      directory = [ "{author}" ];
    };
    redgifs = {
      reverse = true;
      directory = [ "{userName}" ];
    };
    imgur.mp4 = true;
    pixiv = {
      directory = [ "{user[account]} - {user[id]}" ];
      ugoira = true;
      favorite.directory = [
        "{user_bookmark[account]} - {user_bookmark[id]}"
        "Bookmarks"
      ];
      postprocessors = [
        {
          name = "ugoira";
          extension = "webm";
          keep-files = false;
          whitelist = [ "pixiv" ];
          ffmpeg-twopass = true;
          ffmpeg-args = [
            "-c:v"
            "libvpx"
            "-crf"
            "4"
            "-b:v"
            "5000k"
            "-an"
          ];
        }
      ];
    };
    fanbox = {
      embeds = true;
      directory = [
        "{category}"
        "{creatorId}"
      ];
    };
    readcomiconline = {
      chapter-reverse = true;
      quality = "hq";
      captcha = "wait";
      postprocessors = [ "cbz" ];
      directory = [
        "comics"
        "{comic}"
        "{comic} #{issue}"
      ];
    };
    kissmanga = {
      chapter-reverse = true;
      captcha = "wait";
      postprocessors = [ "cbz" ];
      directory = [
        "manga"
        "{subcategory}"
        "{manga}"
        "{manga} Ch.{chapter}{chapter_minor}"
      ];
    };
    mangahere = {
      chapter-reverse = true;
      postprocessors = [ "cbz" ];
      directory = [
        "manga"
        "{subcategory}"
        "{manga}"
        "{manga} Ch.{chapter}{chapter_minor}"
      ];
    };
    mangadex = {
      chapter-reverse = true;
      chapter-filter = "lang == 'en'";
      postprocessors = [ "cbz" ];
      directory = [
        "manga"
        "manga"
        "{manga}"
        "{manga} Ch.{chapter}{chapter_minor}"
      ];
    };
    manganelo = {
      chapter-reverse = true;
      chapter-filter = "lang == 'en'";
      postprocessors = [ "cbz" ];
      directory = [
        "manga"
        "{subcategory}"
        "{manga}"
        "{manga} Ch.{chapter}{chapter_minor}"
      ];
    };
    mangareader = {
      chapter-reverse = true;
      postprocessors = [ "cbz" ];
      directory = [
        "manga"
        "{subcategory}"
        "{manga}"
        "{manga} Ch.{chapter}{chapter_minor}"
      ];
    };
    mangapanda = {
      chapter-reverse = true;
      postprocessors = [ "cbz" ];
      directory = [
        "manga"
        "{subcategory}"
        "{manga}"
        "{manga} Ch.{chapter}{chapter_minor}"
      ];
    };
    webtoons = {
      chapter-reverse = true;
      postprocessors = [ "cbz" ];
      directory = [
        "webtoons"
        "{comic}"
        "{comic} #{episode}"
      ];
    };
  };
  output.mode = "auto";
  downloader = {
    part = true;
    ytdl = {
      logging = true;
      format = "bestvideo+bestaudio/best";
      module = "yt_dlp";
      forward-cookies = true;
    };
    http = {
      rate = null;
      retries = 5;
      timeout = 10.0;
      verify = true;
    };
  };
  postprocessor.cbz = {
    name = "zip";
    compression = "store";
    mode = "safe";
    extension = "cbz";
  };
}
