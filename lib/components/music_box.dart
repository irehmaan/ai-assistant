import 'package:aiassistant/home/widgets/musicplayer_widget.dart';
import 'package:aiassistant/services/musciplayer/songmodel/songModel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MusicBox extends StatelessWidget {
  late Song song;
  List<Song> songlist;
  int index;
  MusicBox(
      {super.key,
      required this.song,
      required this.songlist,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => Music_Player(
                          song: song,
                          songs: songlist,
                          initialIndex: index,
                        )));
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  song.photo,
                  height: 70,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.trackName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                          text: song.collection.substring(
                            0,
                            song.collection.length > 30
                                ? 30
                                : song.collection.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.play_circle,
                    size: 30,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
