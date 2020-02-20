import 'package:flutter/services.dart';
import 'package:flutter_music_app/models/lyric_model.dart';

class Utils {
  static Future<Lyric> getLyricFromTxt(String lrc) async {
    List<LyricSlice> slices = new List();
    // return await rootBundle
    //     .loadString('images/lyric.txt')
    //     .then((String result) {
      List<String> list = lrc.split("\n");
      print("lines:" + list.length.toString() );
      for (String line in list) {
        print(line);
        if (line.startsWith("[")) {
          slices.add(getLyricSlice(line));
        }
      }
      Lyric lyric = new Lyric(slices);
      return lyric;
    // });
  }

  static LyricSlice getLyricSlice(String line) {
    LyricSlice lyricSlice = new LyricSlice();
    lyricSlice.slice = line.substring(11);
    lyricSlice.inSecond =
        int.parse(line.substring(1, 3)) * 60 + int.parse(line.substring(4, 6));
    print(lyricSlice.inSecond.toString() + "-----" + lyricSlice.slice);
    return lyricSlice;
  }
}
