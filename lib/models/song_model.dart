import 'dart:math';
import 'package:flutter/material.dart';
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
}

class SongModel with ChangeNotifier {
  List<Data> _songs;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  Duration _duration;
  Duration get duration => _duration;
  setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  Duration _position;
  num _slideValue;
  num get slideValue => _slideValue;
  setSlideValue(num slideValue) {
    _slideValue = slideValue;
  }

  Duration get position => _position;
  setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  int _currentSongIndex = 0;

  List<Data> get songs => _songs;
  setSongs(List<Data> songs) {
    _songs = songs;
    notifyListeners();
  }

  addSongs(List<Data> songs) {
    _songs.addAll(songs);
    notifyListeners();
  }

  int get length => _songs.length;
  int get songNumber => _currentSongIndex + 1;

  setCurrentIndex(int index) {
    _currentSongIndex = index;
    notifyListeners();
  }

  Data get currentSong => _songs[_currentSongIndex];

  Data get nextSong {
    if (_currentSongIndex < length) {
      _currentSongIndex++;
    }
    //if (_currentSongIndex >= length) return null;
    if (_currentSongIndex >= length) {
      _currentSongIndex = 0;
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Data get randomSong {
    Random r = new Random();
    _currentSongIndex = r.nextInt(_songs.length);
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Data get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    //if (_currentSongIndex < 0) return null;
    if (_currentSongIndex < 0) {
      _currentSongIndex = length - 1;
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }
}
