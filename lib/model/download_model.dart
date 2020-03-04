import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/config/storage_manager.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_list_model.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kDownloadList = 'kDownloadList';
const String kDirectoryPath = 'kDirectoryPath';

/// 我的下载列表
class DownloadListModel extends ViewStateListModel<Song> {
  DownloadModel downloadModel;

  DownloadListModel({this.downloadModel});
  @override
  Future<List<Song>> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    List<Song> downloadList =
        (localStorage.getItem(kDownloadList) ?? []).map<Song>((item) {
      return Song.fromJsonMap(item);
    }).toList();
    downloadModel.setDownloads(downloadList);
    setIdle();
    return downloadList;
  }
}

class DownloadModel with ChangeNotifier {
  DownloadModel() {
    _directoryPath = StorageManager.sharedPreferences.getString(kDirectoryPath);
  }
  List<Song> _downloadSong;
  List<Song> get downloadSong => _downloadSong;

  setDownloads(List<Song> downloadSong) {
    _downloadSong = downloadSong;
    notifyListeners();
  }

  download(Song song) {
    if (_downloadSong.contains(song)) {
      removeFile(song);
    } else {
      downloadFile(song);
    }
  }

  String getSongUrl(Song s) {
    return 'http://music.163.com/song/media/outer/url?id=${s.songid}.mp3';
  }

  Future downloadFile(Song s) async {
    final bytes = await readBytes(getSongUrl(s));
    final dir = await getApplicationDocumentsDirectory();
    setDirectoryPath(dir.path);
    final file = File('${dir.path}/${s.songid}.mp3');

    if (await file.exists()) {
      return;
    }

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      _downloadSong.add(s);
      saveData();
      notifyListeners();
    }
  }

  String _directoryPath;
  String get getDirectoryPath => _directoryPath;
  setDirectoryPath(String directoryPath) {
    _directoryPath = directoryPath;
    StorageManager.sharedPreferences.setString(kDirectoryPath, _directoryPath);
  }

  Future removeFile(Song s) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${s.songid}.mp3');
    setDirectoryPath(dir.path);
    if (await file.exists()) {
      await file.delete();
      _downloadSong.remove(s);
      saveData();
      notifyListeners();
    }
  }

  saveData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    localStorage.setItem(kDownloadList, _downloadSong);
  }

  isDownload(Song newSong) {
    bool isDownload = false;
    for (int i = 0; i < _downloadSong.length; i++) {
      if (_downloadSong[i].songid == newSong.songid) {
        isDownload = true;
        break;
      }
    }
    return isDownload;
  }
}
