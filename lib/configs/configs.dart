// ignore_for_file: constant_identifier_names

class Configs {
  /*
  Obtain your OpenAI API key and paste it below.
  */
  static const OpenAIKey = 'YOUR_OPEN_API_KEY';

  static String getTrend(String query) {
    return "https://itunes.apple.com/search?term=$query&entity=musicTrack&limit =50";
  }
}
