import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class SongListModel extends ViewStateRefreshListModel<Data> {
  final String input;

  SongListModel({this.input});

  @override
  Future<List<Data>> loadData({int pageNum}) async {
    return await BaseRepository.fetchSongList(input, pageNum);
  }

  List<Data> _songs;
  int _currentSongIndex = -1;
  AudioPlayer _audioPlayer = new AudioPlayer();

  List<Data> get songs => _songs;
  setSongs(List<Data> songs) {
    _songs = songs;
    notifyListeners();
  }

  int get length => _songs.length;
  int get songNumber => _currentSongIndex + 1;

  setCurrentIndex(int index) {
    _currentSongIndex = index;
  }

  int get currentIndex => _currentSongIndex;

  Data get nextSong {
    print('$_currentSongIndex'+'---$length');
    if (_currentSongIndex < length) {
      _currentSongIndex++;
    }
    if (_currentSongIndex >= length) return null;
    return _songs[_currentSongIndex];
  }

  Data get randomSong {
    Random r = new Random();
    return _songs[r.nextInt(_songs.length)];
  }

  Data get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return _songs[_currentSongIndex];
  }

  AudioPlayer get audioPlayer => _audioPlayer;
}
