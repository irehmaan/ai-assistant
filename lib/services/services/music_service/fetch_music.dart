import 'dart:convert';

import 'package:aiassistant/configs/configs.dart';
import 'package:aiassistant/services/apiclient/apiClient.dart';
import 'package:aiassistant/services/musciplayer/songmodel/songModel.dart';
import 'package:dio/dio.dart';

class FetchMusic {
  final ApiClient apiClient = ApiClient();
  Future<Object> getSong(String prompt) async {
    final url = Configs.getTrend(prompt);

    Response response = await apiClient.fetchMusic(url);

    try {
      if (response.statusCode == 200) {
        dynamic ob = jsonDecode(response.data);

        List<dynamic> list = ob['results'];
        // print(list);
        List<Song> songsList = list.map((e) => Song.SongFromJson(e)).toList();

        return songsList;
      }
      return "An Error Occured";
    } catch (e) {
      return e.toString();
    }
  }
}
