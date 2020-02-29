import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_list_model.dart';
import 'package:localstorage/localstorage.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kFavoriteList = 'kFavoriteList';

/// 我的收藏列表
class FavoriteListModel extends ViewStateListModel<Song> {
  FavoriteModel favoriteModel;

  FavoriteListModel({this.favoriteModel});
  @override
  Future<List<Song>> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    List<Song> favoriteList =
        (localStorage.getItem(kFavoriteList) ?? []).map<Song>((item) {
      return Song.fromJsonMap(item);
    }).toList();
    favoriteModel.setFavorites(favoriteList);
    setIdle();
    return favoriteList;
  }
}

class FavoriteModel with ChangeNotifier {
  List<Song> _favoriteSong;
  List<Song> get favoriteSong => _favoriteSong;

  setFavorites(List<Song> favoriteSong) {
    _favoriteSong = favoriteSong;
    notifyListeners();
  }

  collect(Song song) {
    if (_favoriteSong.contains(song)) {
      _favoriteSong.remove(song);
    } else {
      _favoriteSong.add(song);
    }
    saveData();
    notifyListeners();
  }

  saveData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    localStorage.setItem(kFavoriteList, _favoriteSong);
  }

  isCollect(Song newSong) {
    bool isCollect = false;
    for (int i = 0; i < _favoriteSong.length; i++) {
      if (_favoriteSong[i].songid == newSong.songid) {
        isCollect = true;
        break;
      }
    }
    return isCollect;
  }
}
