import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../songmodel/songModel.dart';

enum AudioSate { PLAYING, PAUSED, REPEAT, RESUME, STOPPED }

class Player with ChangeNotifier {
  bool isPlaying = false;
  bool isPaused = false;
  bool isRepeat = false;

  Duration? _duration;
  Duration? _position;
  Duration? get songDuration => _duration;
  Duration? get songPosition => _position;
  get _durationText => _duration?.toString().split('.').first ?? '';
  get _positionText => _position?.toString().split('.').first ?? '';
  AudioSate _audioSate = AudioSate.STOPPED;
  AudioSate get audioState => _audioSate;
  AudioPlayer audioPlayer = AudioPlayer();

  get position => _positionText;
  get duration => _durationText;

  Player() {
    audioPlayer.onPositionChanged.listen((p) {
      _position = p;

      notifyListeners();
    });

    audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        _position = const Duration(seconds: 0);
        isPlaying = false;

        notifyListeners();
      }
    });
  }

  Future<void> playAudio(String url) async {
    await audioPlayer.play(UrlSource(url));
    isPlaying = true;
    notifyListeners();
  }

  void playAssetAudio(String url) async {
    await audioPlayer.play(AssetSource(url));

    notifyListeners();
  }

  pauseAudio() async {
    if (isPlaying == true) {
      await audioPlayer.pause();
      isPlaying = false;

      notifyListeners();
    }
  }

  resumeAudio() async {
    await audioPlayer.resume();
    isPlaying = true;
    notifyListeners();
  }

  releaseAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.release);
    isRepeat = false;

    notifyListeners();
  }

  repeatAudio() async {
    await audioPlayer.setReleaseMode(ReleaseMode.loop);
    isRepeat = true;
    notifyListeners();
  }

  stopAudio() async {
    audioPlayer.stop();
    isPlaying = false;
    notifyListeners();
  }

  seekAudio(Duration position) async {
    await audioPlayer.seek(position);

    notifyListeners();
  }

  void playPrevioustSong(int _currentSongIndex, List<Song>? songs) {
    int prevIndex = _currentSongIndex - 1;
    if (prevIndex >= 0) {
      _currentSongIndex = prevIndex;

      playAudio(songs![prevIndex].songurl);
    }
    notifyListeners();
  }
}
