import 'package:aiassistant/components/music_box.dart';
import 'package:aiassistant/services/musciplayer/songmodel/songModel.dart';
import 'package:aiassistant/services/services/music_service/fetch_music.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SongWidget extends StatelessWidget {
  String prompt;
  final String? genContent; // Add genContent as a parameter

  SongWidget({Key? key, required this.prompt, this.genContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FetchMusic().getSong(prompt),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something Went wrong !!"),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final bool shouldShowListView = genContent == null;

        return Visibility(
          visible: shouldShowListView,
          child: ListView.builder(
            padding: const EdgeInsets.all(6),
            scrollDirection: Axis.vertical,
            // physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Song song = snapshot.data[index];
              List<Song> songlist = snapshot.data;

              return MusicBox(
                song: song,
                songlist: songlist,
                index: index,
              );
            },
          ),
        );
      },
    );
  }
}
