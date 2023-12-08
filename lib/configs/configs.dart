// ignore_for_file: constant_identifier_names

class Configs {
  /*
  Obtain your OpenAI API key and paste it below.
  */
  static const OpenAIKey =
      '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';

  static String getTrend(String query) {
    return "https://itunes.apple.com/search?term=$query&entity=musicTrack&limit =50";
  }
}
