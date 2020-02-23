class Lyric {
  List<LyricSlice> slices;

  Lyric(this.slices);
}

class LyricSlice {
  int inSecond; //歌词片段开始时间
  String slice; //片段内容

  lyric(int inSecond, String slice) {
    this.inSecond = inSecond;
    this.slice = slice;
  }
}
