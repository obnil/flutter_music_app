import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/widgets/lyric_panel.dart';

class Player extends StatefulWidget {
  /// 播放列表
  final SongModel songData;

  //是否立即播放
  final bool nowPlay;

  /// 音量
  final double volume;

  /// 错误回调
  final Function(String) onError;

  ///播放完成
  final Function(Data data) onCompleted;

  /// 上一首
  final Function(Data data) onPrevious;

  ///下一首
  final Function(Data data) onNext;

  final Function(bool) onPlaying;

  final Key key;

  final Color color;

  /// 是否是本地资源
  final bool isLocal;

  Player(
      {@required this.songData,
      @required this.onCompleted,
      @required this.onError,
      @required this.onNext,
      @required this.onPrevious,
      this.nowPlay,
      this.key,
      this.volume: 1.0,
      this.onPlaying,
      this.color: Colors.white,
      this.isLocal: false});

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  ///audioPlayer https://pub.dev/packages/audioplayers
  AudioPlayer audioPlayer;
  Duration duration;
  Duration position;
  double sliderValue;
  //Lyric lyric;
  //LyricPanel panel;
  PositionChangeHandler handler;
  SongModel songData;

  @override
  void initState() {
    super.initState();
    initPlayer();
    //initLrc();
  }

  // initLrc() {
  //   if (model.currentSong.lrc.isNotEmpty) {
  //     Utils.getLyricFromTxt(model.currentSong.lrc).then((Lyric lyric) {
  //       print("getLyricFromTxt:" + lyric.slices.length.toString());
  //       setState(() {
  //         this.lyric = lyric;
  //         panel = new LyricPanel(this.lyric);
  //       });
  //     });
  //   }
  // }

  initPlayer() async {
    if (audioPlayer == null) {
      audioPlayer = widget.songData.audioPlayer;
    }
    setState(() {
      songData = widget.songData;
      if (widget.nowPlay == null || widget.nowPlay == false) {
        if (songData.isPlaying) {
          stop();
        }
      }
      play(songData.currentSong);
    });

    audioPlayer
      ..completionHandler = () {
        Data data = songData.nextSong;
        next(data);
        widget.onCompleted(data);
      }
      ..errorHandler = widget.onError
      ..durationHandler = ((duration) {
        songData.setDuration(duration);
      })
      ..positionHandler = ((position) {
        songData.setPosition(position);
        // if (panel != null) {
        //   panel.handler(position.inSeconds);
        // }
      });
    // audioPlayer.onDurationChanged.listen((Duration d) {
    //   songData.setDuration(d);
    // });
    // audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
    //   songData.setPlayState(s);
    // });
  }

  Future play(Data s) async {
    if (s != null) {
      ///s.url在几分钟后过期，采用s.id
      ///http://music.163.com/song/media/outer/url?id=317151.mp3
      final result = await audioPlayer.play('http://music.163.com/song/media/outer/url?id=${s.songid}.mp3');
      if (result == 1) songData.setPlaying(true);
    }
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) {
      songData.setPosition(new Duration());
      songData.setPlaying(false);
    }
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1) {
      songData.setPosition(new Duration());
      songData.setPlaying(false);
    }
  }

  Future next(Data data) async {
    stop();
    play(data);
  }

  Future prev(Data data) async {
    stop();
    play(data);
  }

  String _formatDuration(Duration d) {
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    //print(d.inMinutes.toString() + "======" + d.inSeconds.toString());
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _controllers(context),
    );
  }

  Widget _timer(BuildContext context) {
    var style = new TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          songData.position == null
              ? "--:--"
              : _formatDuration(songData.position),
          style: style,
        ),
        new Text(
          songData.duration == null
              ? "--:--"
              : _formatDuration(songData.duration),
          style: style,
        ),
      ],
    );
  }

  List<Widget> _controllers(BuildContext context) {
    return [
      // lyric != null ? panel : null,
      // const Divider(color: Colors.transparent),
      // const Divider(
      //   color: Colors.transparent,
      //   height: 32.0,
      // ),
      new Slider(
        onChanged: (newValue) {
          int seconds = (songData.duration.inSeconds * newValue).round();
          audioPlayer.seek(new Duration(seconds: seconds));
        },
        value: (songData.position != null && songData.duration != null)
            ? (songData.position.inSeconds / songData.duration.inSeconds)
            : 0.0,
        activeColor: Theme.of(context).accentColor,
      ),
      new Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: _timer(context),
      ),
      new Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Data data = songData.prevSong;
                while (data.url == null) {
                  data = songData.prevSong;
                }
                prev(data);
                widget.onPrevious(data);
              },
              icon: Icon(
                //Icons.skip_previous,
                Icons.fast_rewind,
                size: 25.0,
                color: Colors.grey,
              ),
            ),
            ClipOval(
                child: Container(
              color: Theme.of(context).accentColor.withAlpha(30),
              width: 80.0,
              height: 80.0,
              child: IconButton(
                onPressed: () {
                  if (songData.isPlaying)
                    audioPlayer.pause();
                  else {
                    audioPlayer.resume();
                  }
                  setState(() {
                    songData.setPlaying(!songData.isPlaying);
                    widget.onPlaying(songData.isPlaying);
                  });
                },
                padding: const EdgeInsets.all(0.0),
                icon: Icon(
                  songData.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            )),
            IconButton(
              onPressed: () {
                Data data = songData.nextSong;
                while (data.url == null) {
                  data = songData.nextSong;
                }
                next(data);
                widget.onNext(data);
              },
              icon: Icon(
                //Icons.skip_next,
                Icons.fast_forward,
                size: 25.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
