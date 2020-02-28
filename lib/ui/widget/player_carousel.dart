import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:audio_manager/audio_manager.dart';

class Player extends StatefulWidget {
  /// 播放列表
  final SongModel songData;

  //是否立即播放
  final bool nowPlay;

  /// 音量
  final double volume;

  final Key key;

  final Color color;

  /// 是否是本地资源
  final bool isLocal;

  Player(
      {@required this.songData,
      this.nowPlay,
      this.key,
      this.volume: 1.0,
      this.color: Colors.white,
      this.isLocal: false});

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  Duration _duration;
  Duration _position;
  num _slideValue;
  SongModel _songData;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _songData = widget.songData;
    if (_songData.isPlaying || widget.nowPlay) {
      play(_songData.currentSong);
    }
    setState(() {
      _duration = _songData.duration;
      _position = _songData.position;
      _slideValue = _songData.slideValue;
    });
  }

  void play(Data s) {
    AudioManager.instance
        .start('http://music.163.com/song/media/outer/url?id=${s.songid}.mp3',
            s.title,
            desc: s.author, cover: s.pic)
        .then((err) {
      print(err);
    });

    AudioManager.instance.onEvents((events, args) {
      //print("events $events, args $args");
      switch (events) {
        case AudioManagerEvents.ready:
          print("ready to play");
          AudioManager.instance.seekTo(Duration(seconds: 0));
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
        print("isPlaying ${AudioManager.instance.isPlaying}");
          _songData.setPlaying(AudioManager.instance.isPlaying);
          break;
        case AudioManagerEvents.timeupdate:
          setState(() {
            _duration = AudioManager.instance.duration;
            _position = AudioManager.instance.position;
            _slideValue = _position.inSeconds / _duration.inSeconds;
            _songData.setDuration(_duration);
            _songData.setPosition(_position);
            _songData.setSlideValue(_slideValue);
          });
          //AudioManager.instance.updateLrc(args["position"].toString());
          // print(AudioManager.instance.info);
          break;
        case AudioManagerEvents.error:
          //_error = args;
          // setState(() {});
          break;
        case AudioManagerEvents.next:
          next();
          break;
        case AudioManagerEvents.previous:
          previous();
          break;
        case AudioManagerEvents.ended:
          next();
          break;
        default:
          break;
      }
    });
  }

  void next() {
    Data data = _songData.nextSong;
    while (data.url == null) {
      data = _songData.nextSong;
    }
    play(data);
  }

  void previous() {
    Data data = _songData.prevSong;
    while (data.url == null) {
      data = _songData.prevSong;
    }
    play(data);
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
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
          _formatDuration(_position),
          style: style,
        ),
        new Text(
          _formatDuration(_duration),
          style: style,
        ),
      ],
    );
  }

  List<Widget> _controllers(BuildContext context) {
    return [
      new Slider(
        onChanged: (value) {
          setState(() {
            _slideValue = value;
          });
          Duration seconds =
              Duration(seconds: (_duration.inSeconds * value).round());
          AudioManager.instance.seekTo(seconds);
        },
        value: _slideValue ?? 0,
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
              onPressed: () => previous(),
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
                onPressed: () async {
                  String status = await AudioManager.instance.playOrPause();
                  print("await -- $status");
                },
                icon: Icon(
                  _songData.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 30.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            )),
            IconButton(
              onPressed: () => next(),
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
