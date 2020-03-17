import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
  String _url;
  String get url => _url;
  setUrl(String url) {
    _url = url;
    notifyListeners();
  }

  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayer => _audioPlayer;

  List<Song> _songs;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool _isRepeat = true;
  bool get isRepeat => _isRepeat;
  changeRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  bool _showList = false;
  bool get showList => _showList;
  setShowList(bool showList) {
    _showList = showList;
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
  bool _playNow = false;
  bool get playNow => _playNow;
  setPlayNow(bool playNow) {
    _playNow = playNow;
    notifyListeners();
  }

  Song get currentSong => _songs[_currentSongIndex];

  Song get nextSong {
    if (isRepeat) {
      if (_currentSongIndex < length) {
        _currentSongIndex++;
      }
      if (_currentSongIndex == length) {
        _currentSongIndex = 0;
      }
    } else {
      Random r = new Random();
      _currentSongIndex = r.nextInt(_songs.length);
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Song get prevSong {
    if (isRepeat) {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      }
      if (_currentSongIndex == 0) {
        _currentSongIndex = length - 1;
      }
    } else {
      Random r = new Random();
      _currentSongIndex = r.nextInt(_songs.length);
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Duration _position;
  Duration get position => _position;
  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  Duration _duration;
  Duration get duration => _duration;
  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
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
