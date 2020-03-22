import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/model/download_model.dart';
import 'package:flutter_music_app/model/song_model.dart';

class Player extends StatefulWidget {
  /// 播放列表
  final SongModel songData;
  final DownloadModel downloadData;

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
      @required this.downloadData,
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
  SongModel _songData;
  DownloadModel _downloadData;
  bool _isSeeking = false;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;

  @override
  void initState() {
    super.initState();
    _songData = widget.songData;
    _downloadData = widget.downloadData;
    _initAudioPlayer(_songData);
    if (_songData.isPlaying || widget.nowPlay) {
      play(_songData.currentSong);
    }
  }

  void _initAudioPlayer(SongModel songData) {
    _audioPlayer = songData.audioPlayer;
    _position = _songData.position;
    _duration = _songData.duration;
    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration;
        _songData.setDuration(_duration);
      });

      // TODO implemented for iOS, waiting for android impl
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
            title: _songData.currentSong.title,
            artist: _songData.currentSong.author,
            //albumTitle: 'Name or blank',
            imageUrl: _songData.currentSong.pic,
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: duration,
            elapsedTime: Duration(seconds: 0));
      }
    });

    _audioPlayer.onAudioPositionChanged.listen((position) {
      if (!mounted) return;
      if (_isSeeking) return;
      setState(() {
        _position = position;
        _songData.setPosition(_position);
      });
    });

    _audioPlayer.onPlayerCompletion.listen((event) {
      // // _onComplete();
      // setState(() {
      //   _position = _duration;
      // });
      next();
    });

    _audioPlayer.onSeekComplete.listen((finished) {
      _isSeeking = false;
    });

    _audioPlayer.onPlayerError.listen((msg) {
      if (!mounted) return;
      print('audioPlayer error : $msg');
      setState(() {
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
        _songData.setPlaying(_audioPlayerState == AudioPlayerState.PLAYING);
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
        _songData.setPlaying(_audioPlayerState == AudioPlayerState.PLAYING);
      });
    });
  }

  String getSongUrl(Song s) {
    return 'http://music.163.com/song/media/outer/url?id=${s.songid}.mp3';
  }

  void play(Song s) async {
    String url;
    if (_downloadData.isDownload(s)) {
      url = _downloadData.getDirectoryPath + '/${s.songid}.mp3';
    } else {
      url = getSongUrl(s);
    }
    if (url == _songData.url) {
      int result = await _audioPlayer.setUrl(url);
      if (result == 1) {
        _songData.setPlaying(true);
      }
    } else {
      int result = await _audioPlayer.play(url);
      if (result == 1) {
        _songData.setPlaying(true);
      }
      _songData.setUrl(url);
    }
  }

  void pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _songData.setPlaying(false));
  }

  void resume() async {
    final result = await _audioPlayer.resume();
    if (result == 1) setState(() => _songData.setPlaying(true));
  }

  void next() {
    Song data = _songData.nextSong;
    while (data.url == null) {
      data = _songData.nextSong;
    }
    play(data);
  }

  void previous() {
    Song data = _songData.prevSong;
    while (data.url == null) {
      data = _songData.prevSong;
    }
    play(data);
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }

  @override
  Widget build(BuildContext context) {
    if (_songData.playNow) {
      play(_songData.currentSong);
    }
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
      Visibility(
        visible: !_songData.showList,
        child: new Slider(
          onChangeStart: (v) {
            _isSeeking = true;
          },
          onChanged: (value) {
            setState(() {
              _position =
                  Duration(seconds: (_duration.inSeconds * value).round());
            });
          },
          onChangeEnd: (value) {
            setState(() {
              _position =
                  Duration(seconds: (_duration.inSeconds * value).round());
            });
            _audioPlayer.seek(_position);
          },
          value: (_position != null &&
                  _duration != null &&
                  _position.inSeconds > 0 &&
                  _position.inSeconds < _duration.inSeconds)
              ? _position.inSeconds / _duration.inSeconds
              : 0.0,
          activeColor: Theme.of(context).accentColor,
        ),
      ),
      Visibility(
        visible: !_songData.showList,
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: _timer(context),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Visibility(
              visible: _songData.showList,
              child: IconButton(
                onPressed: () => _songData.setShowList(!_songData.showList),
                icon: Icon(
                  Icons.list,
                  size: 25.0,
                  color: Colors.grey,
                ),
              ),
            ),
            IconButton(
              onPressed: () => previous(),
              icon: Icon(
                //Icons.skip_previous,
                Icons.fast_rewind,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),
            ClipOval(
                child: Container(
              color: Theme.of(context).accentColor.withAlpha(30),
              width: 70.0,
              height: 70.0,
              child: IconButton(
                onPressed: () {
                  _songData.isPlaying ? pause() : resume();
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
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),
            Visibility(
              visible: _songData.showList,
              child: IconButton(
                onPressed: () => _songData.changeRepeat(),
                icon: _songData.isRepeat == true
                    ? Icon(
                        Icons.repeat,
                        size: 25.0,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.shuffle,
                        size: 25.0,
                        color: Colors.grey,
                      ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // void _onComplete() {
  //   setState(() => _songData.setPlayState(PlayState.stopped));
  // }
}
