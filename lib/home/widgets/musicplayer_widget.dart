import 'package:aiassistant/services/musciplayer/audioPlayerService/audioPlayer.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../../services/musciplayer/songmodel/songModel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
// ignore: must_be_immutable, camel_case_types
class Music_Player extends StatefulWidget {
  late Song song;
  late List<Song>? songs;
  final int initialIndex;

  Music_Player(
      {super.key, required this.song, this.initialIndex = 0, this.songs});

  @override
  State<Music_Player> createState() => _Music_PlayerState();
}

// ignore: camel_case_types
class _Music_PlayerState extends State<Music_Player> {
  int _currentSongIndex = 0;
  bool isFavourite = false;

  @override
  void initState() {
    _currentSongIndex = widget.initialIndex;
    context.read<Player>().playAudio(widget.songs![_currentSongIndex].songurl);
    super.initState();
  }

  void playNextSong() {
    int nextIndex = _currentSongIndex + 1;
    if (nextIndex < widget.songs!.length) {
      setState(() {
        _currentSongIndex = nextIndex;
      });
      context.read<Player>().playAudio(widget.songs![nextIndex].songurl);
    }
  }

  void playPrevioustSong() {
    int prevIndex = _currentSongIndex - 1;
    if (prevIndex >= 0) {
      setState(() {
        _currentSongIndex = prevIndex;
      });
      context.read<Player>().playAudio(widget.songs![prevIndex].songurl);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = Provider.of<Player>(context).isPlaying;
    bool isRepeat = Provider.of<Player>(context).isRepeat;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100.withOpacity(0.6),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<Player>().stopAudio();
                    },
                    icon: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      child: Icon(Icons.arrow_back_ios),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.songs![_currentSongIndex].photo,
                      height: 330,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: SizedBox(
                    height: size.height / 28,
                    width: size.width / 1.2,
                    child: Marquee(
                      fadingEdgeStartFraction: 0.39,
                      fadingEdgeEndFraction: 0.39,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 23),
                      scrollAxis: Axis.horizontal, //scroll direction
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 300.0,
                      velocity: 40.0, //speed
                      pauseAfterRound: const Duration(seconds: 0),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 3),
                      accelerationCurve: standardEasing,
                      decelerationDuration: const Duration(seconds: 3),
                      decelerationCurve: standardEasing,
                      text: widget.songs![_currentSongIndex].trackName,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10),
                  child: Text(
                    widget.songs![_currentSongIndex].collection.substring(
                        0,
                        widget.songs![_currentSongIndex].collection.length > 40
                            ? 40
                            : widget
                                .songs![_currentSongIndex].collection.length),
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade200,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
            Consumer<Player>(
              builder: (BuildContext context, data, Widget? child) {
                return Slider(
                  value: (data.songPosition != null &&
                          data.songDuration != null &&
                          data.songPosition!.inMilliseconds > 0 &&
                          data.songPosition!.inMilliseconds <
                              data.songDuration!.inMilliseconds)
                      ? data.songPosition!.inMilliseconds /
                          data.songDuration!.inMilliseconds
                      : 0.0,
                  onChanged: (v) {
                    final posi = v * data.songDuration!.inMilliseconds;
                    data.seekAudio(Duration(milliseconds: posi.round()));
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.read<Player>().position,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 70,
                  // ),
                  Text(
                    context.read<Player>().duration,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: playPrevioustSong,
                    icon: const Icon(Icons.skip_previous, size: 28)),
                IconButton(
                    onPressed: () {
                      if (isPlaying == false) {
                        Provider.of<Player>(context, listen: false).playAudio(
                            widget.songs![_currentSongIndex].songurl);
                        setState(() {
                          isPlaying = true;
                        });
                      } else {
                        setState(() {
                          Provider.of<Player>(context, listen: false)
                              .pauseAudio();
                          isPlaying = false;
                        });
                      }
                    },
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 28)),
                IconButton(
                    onPressed: playNextSong,
                    icon: const Icon(
                      Icons.skip_next,
                      size: 28,
                    )),
                IconButton(
                    onPressed: () {
                      if (isRepeat == false) {
                        setState(() {
                          Provider.of<Player>(context, listen: false)
                              .repeatAudio();
                          isRepeat = true;
                          isPlaying = true;
                        });
                      } else {
                        setState(() {
                          Provider.of<Player>(context, listen: false)
                              .releaseAudio();
                          isRepeat = false;
                        });
                      }
                    },
                    icon: Icon(isRepeat ? Icons.repeat_one : Icons.repeat,
                        size: 28)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
