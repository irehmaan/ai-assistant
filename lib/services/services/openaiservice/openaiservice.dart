
import 'package:aiassistant/services/apiclient/apiClient.dart';


class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtPrompted(String prompt) async {
    try {
      const completionUrl = 'https://api.openai.com/v1/chat/completions';
      final ApiClient apiClient = ApiClient();
      final res = await apiClient.queryPost(completionUrl, prompt);

      print(res.data);
      if (res.statusCode == 200) {
        String content = res.data['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'yes':
          case 'Yes':
          case 'Yes.':
          case 'yes.':
            final res = await Dall_E(prompt);
            return res;

          default:
            final res = await ChatGPT(prompt);
            return res;
        }
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> ChatGPT(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    const completionUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final ApiClient apiClient = ApiClient();
      final res = await apiClient.callChatGpt(completionUrl, prompt, messages);

      if (res.statusCode == 200) {
        String content = res.data['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        print(content);
        return content;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> Dall_E(String prompt) async {
    const completionUrl = 'https://api.openai.com/v1/images/generations';
    try {
      final ApiClient apiClient = ApiClient();
      final res = await apiClient.callDallE(completionUrl, prompt, messages);

      if (res.statusCode == 200) {
        String imgUrl = res.data['data'][0]['url'];
        imgUrl = imgUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imgUrl,
        });
        // print(imgUrl);
        return imgUrl;
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
    }
  }

  // Future<Song> getSong(String query) async {
  //   final url = Configs.getTrend(query);

  //   return [];
  // }
}
