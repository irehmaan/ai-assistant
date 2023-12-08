import 'package:aiassistant/configs/configs.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();

  queryPost(String completionUrl, String prompt) {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Configs.OpenAIKey}'
    };
    final Map<String, dynamic> data = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "user",
          "content":
              "Does this message wants to generate or want an AI image, art, or anything similar? $prompt. Simply answer yes or no."
        }
      ],
    };
    return _dio.post(completionUrl,
        options: Options(headers: headers), data: data);
  }

  callChatGpt(
      String completionUrl, String prompt, List<Map<String, String>> messages) {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Configs.OpenAIKey}'
    };
    final Map<String, dynamic> data = {
      "model": "gpt-3.5-turbo",
      "messages": messages
    };
    return _dio.post(completionUrl,
        options: Options(headers: headers), data: data);
  }

  callDallE(
      String completionUrl, String prompt, List<Map<String, String>> messages) {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Configs.OpenAIKey}'
    };
    final Map<String, dynamic> data = {"prompt": prompt, "n": 1};
    return _dio.post(completionUrl,
        options: Options(headers: headers), data: data);
  }

  fetchMusic(String prompt) {
    return _dio.get(prompt);
  }
}
