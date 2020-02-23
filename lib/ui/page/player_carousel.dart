import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/lyric_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/utils.dart';
import 'package:flutter_music_app/widgets/lyric_panel.dart';

class Player extends StatefulWidget {
  /// [AudioPlayer] 播放地址
  final Data data;

  final SongListModel songData;

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
      {@required this.data,
      @required this.songData,
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
  AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration;
  Duration position;
  double sliderValue;
  Lyric lyric;
  LyricPanel panel;
  PositionChangeHandler handler;
  SongListModel songData;
  Data data;

  @override
  void initState() {
    super.initState();
    initPlayer();
    initLrc();
  }

  initLrc() {
    print("audioUrl:" + widget.data.url);
    if (widget.data.lrc.isNotEmpty) {
      Utils.getLyricFromTxt(widget.data.lrc).then((Lyric lyric) {
        print("getLyricFromTxt:" + lyric.slices.length.toString());
        setState(() {
          this.lyric = lyric;
          panel = new LyricPanel(this.lyric);
        });
      });
    }
  }

  initPlayer() async {
    if (audioPlayer == null) {
      audioPlayer = widget.songData.audioPlayer;
    }
    setState(() {
      data = widget.data;
      if (widget.nowPlay == null || widget.nowPlay == false) {
        if (isPlaying) {
          stop();
        }
      }
      play(data);
    });

    audioPlayer
      ..completionHandler = () {
        Data data = widget.songData.nextSong;
        if (data.url != null) {
          next(data);
          widget.onCompleted(data);
        }
      }
      ..errorHandler = widget.onError
      ..durationHandler = ((duration) {
        setState(() {
          this.duration = duration;

          if (position != null) {
            this.sliderValue = (position.inSeconds / duration.inSeconds);
          }
        });
      })
      ..positionHandler = ((position) {
        setState(() {
          this.position = position;

          if (panel != null) {
            panel.handler(position.inSeconds);
          }

          if (duration != null) {
            this.sliderValue = (position.inSeconds / duration.inSeconds);
          }
        });
      });
  }

  Future play(Data s) async {
    if (s != null) {
      final result = await audioPlayer.play(s.url);
      if (result == 1)
        setState(() {
          isPlaying = true;
          data = s;
          widget.onPlaying(isPlaying);
        });
    }
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => isPlaying = false);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        isPlaying = false;
        position = new Duration();
      });
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
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          position == null ? "--:--" : _formatDuration(position),
          style: style,
        ),
        new Text(
          duration == null ? "--:--" : _formatDuration(duration),
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
          if (duration != null) {
            int seconds = (duration.inSeconds * newValue).round();
            audioPlayer.seek(new Duration(seconds: seconds));
          }
        },
        value: sliderValue ?? 0.0,
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
                Data data = widget.songData.prevSong;
                if (data.url != null) {
                  prev(data);
                  Future.delayed(Duration(milliseconds: 200)).then((e) {
                    widget.onPrevious(data);
                  });
                } else {
                  debugPrint('songlist is over');
                }
              },
              icon: Icon(
                Icons.skip_previous,
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
                  if (isPlaying)
                    audioPlayer.pause();
                  else {
                    audioPlayer.resume();
                  }
                  setState(() {
                    isPlaying = !isPlaying;
                    widget.onPlaying(isPlaying);
                  });
                },
                padding: const EdgeInsets.all(0.0),
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            )),
            IconButton(
              onPressed: () {
                Data data = widget.songData.nextSong;
                if (data.url != null) {
                  next(data);
                  Future.delayed(Duration(milliseconds: 200)).then((e) {
                    widget.onNext(data);
                  });
                } else {
                  debugPrint('songlist is over');
                }
              },
              icon: Icon(
                Icons.skip_next,
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
