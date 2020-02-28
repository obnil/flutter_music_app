import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class SongListModel extends ViewStateRefreshListModel<Song> {
  final String input;

  SongListModel({this.input});

  @override
  Future<List<Song>> loadData({int pageNum}) async {
    return await BaseRepository.fetchSongList(input, pageNum);
  }
}

class SongModel with ChangeNotifier {
  List<Song> _songs;
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool _showList = false;
  bool get showList => _showList;
  setShowList(bool showList) {
    _showList = showList;
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

  List<Song> get songs => _songs;
  setSongs(List<Song> songs) {
    _songs = songs;
    notifyListeners();
  }

  addSongs(List<Song> songs) {
    _songs.addAll(songs);
    notifyListeners();
  }

  int get length => _songs.length;
  int get songNumber => _currentSongIndex + 1;

  setCurrentIndex(int index) {
    _currentSongIndex = index;
    notifyListeners();
  }

  /// 在播放列表界面点击后立刻播放
  bool _playNow;
  bool get playNow => _playNow;
  setPlayNow(bool playNow) {
    _playNow = playNow;
    notifyListeners();
  }

  Song get currentSong => _songs[_currentSongIndex];

  Song get nextSong {
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

  Song get randomSong {
    Random r = new Random();
    _currentSongIndex = r.nextInt(_songs.length);
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Song get prevSong {
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

class Song {
  String type;
  String link;
  int songid;
  String title;
  String author;
  String lrc;
  String url;
  String pic;

  Song.fromJsonMap(Map<String, dynamic> map)
      : type = map["type"],
        link = map["link"],
        songid = map["songid"],
        title = map["title"],
        author = map["author"],
        lrc = map["lrc"],
        url = map["url"],
        pic = map["pic"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['link'] = link;
    data['songid'] = songid;
    data['title'] = title;
    data['author'] = author;
    data['lrc'] = lrc;
    data['url'] = url;
    data['pic'] = pic;
    return data;
  }
}
