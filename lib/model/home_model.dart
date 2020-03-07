import 'dart:math';

import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/view_state_refresh_list_model.dart';
import 'package:flutter_music_app/service/base_repository.dart';

class HomeModel extends ViewStateRefreshListModel {
  static const albumValueList = ['酒吧', '怀旧', '女歌手', '经典', '热门'];
  static const forYouValueList = ['华语', '流行', '轻音乐', '排行榜', '抖音'];

  List<Song> _albums;
  List<Song> _forYou;
  List<Song> get albums => _albums;

  List<Song> get forYou => _forYou;
  @override
  Future<List<Song>> loadData({int pageNum}) async {
    List<Future> futures = [];
    Random r = new Random();
    int _randomSongAlbum = r.nextInt(albumValueList.length);
    int _randomSongForYou = r.nextInt(forYouValueList.length);
    String inputAlbums = albumValueList[_randomSongAlbum];
    String inputForYou = forYouValueList[_randomSongForYou];
    futures.add(BaseRepository.fetchSongList(inputAlbums, pageNum));
    futures.add(BaseRepository.fetchSongList(inputForYou, pageNum));

    var result = await Future.wait(futures);
    _albums = result[0];
    _forYou = result[1];
    return result[1];
  }
}
