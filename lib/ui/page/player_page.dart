import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/anims/player_anim.dart';
import 'package:flutter_music_app/model/download_model.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/widget/player_carousel.dart';
import 'package:flutter_music_app/ui/widget/song_list_carousel.dart';
import 'package:provider/provider.dart';

class PlayPage extends StatefulWidget {
  final bool nowPlay;

  PlayPage({this.nowPlay});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  initState() {
    super.initState();
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  String getSongUrl(Song s) {
    return 'http://music.163.com/song/media/outer/url?id=${s.songid}.mp3';
  }

  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    FavoriteModel favouriteModel = Provider.of(context);
    if (songModel.isPlaying) {
      controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  !songModel.showList
                      ? Column(
                          children: <Widget>[
                            AppBarCarousel(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05),
                            RotatePlayer(
                                animation:
                                    _commonTween.animate(controllerPlayer)),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () => songModel
                                        .setShowList(!songModel.showList),
                                    icon: Icon(
                                      Icons.list,
                                      size: 25.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => songModel.changeRepeat(),
                                    icon: songModel.isRepeat == true
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
                                  IconButton(
                                    onPressed: () => favouriteModel
                                        .collect(songModel.currentSong),
                                    icon: favouriteModel.isCollect(
                                                songModel.currentSong) ==
                                            true
                                        ? Icon(
                                            Icons.favorite,
                                            size: 25.0,
                                            color:
                                                Theme.of(context).accentColor,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            size: 25.0,
                                            color: Colors.grey,
                                          ),
                                  ),
                                  IconButton(
                                    onPressed: () => downloadModel
                                        .download(songModel.currentSong),
                                    icon: downloadModel
                                            .isDownload(songModel.currentSong)
                                        ? Icon(
                                            Icons.cloud_done,
                                            size: 25.0,
                                            color:
                                                Theme.of(context).accentColor,
                                          )
                                        : Icon(
                                            Icons.cloud_download,
                                            size: 25.0,
                                            color: Colors.grey,
                                          ),
                                  ),
                                ]),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text(
                              songModel.currentSong.author,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              songModel.currentSong.title,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )
                      : SongListCarousel(),
                ],
              ),
            ),
            Player(
              songData: songModel,
              downloadData: downloadModel,
              nowPlay: widget.nowPlay,
            ),
          ],
        ),
      ),
    );
  }
}
