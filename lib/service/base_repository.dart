import 'package:flutter_music_app/config/net/base_api.dart';
import 'package:flutter_music_app/models/data_model.dart';

class BaseRepository {
  /// 登录
  /// [Http._init] 添加了拦截器 设置了自动cookie.
  static Future fetchSongList(String input, int page) async {
    var response = await http.post('/', data: {
      'input': input,
      'type': 'netease',
      'page': page,
      'filter': 'name',
    });
    return response.data
        .map<Data>((item) => Data.fromJsonMap(item))
        .toList();
  }
}
