import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/app_bar.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/ui/page/player_carousel.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  final bool nowPlay;

  PlayScreen({this.nowPlay});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  initState() {
    super.initState();
    controllerRecord = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationRecord =
        new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);
    animationRecord.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerRecord.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerRecord.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    if (songModel.isPlaying) {
      controllerRecord.forward();
    } else {
      controllerRecord.stop(canceled: false);
    }
    final Animation<double> animation = _commonTween.animate(controllerRecord);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                AppBarCarousel(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                RotationTransition(
                    turns: animation,
                    child: Hero(
                      tag: songModel.currentSong.title + songModel.currentSong.author,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(songModel.currentSong.pic),
                          ),
                        ),
                      ),
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          //widget.onPrevious();
                        },
                        icon: Icon(
                          Icons.list,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //widget.onPrevious();
                        },
                        icon: Icon(
                          Icons.repeat,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //widget.onPrevious();
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //widget.onPrevious();
                        },
                        icon: Icon(
                          Icons.volume_down,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                    ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  songModel.currentSong.title,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  songModel.currentSong.author,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
            Player(
              onError: (e) {
                debugPrint(e);
              },
              onPrevious: (Data data) {},
              onNext: (Data data) {},
              onCompleted: (Data data) {
                debugPrint('complete');
              },
              onPlaying: (isPlaying) {
                if (isPlaying) {
                  controllerRecord.forward();
                  debugPrint('pause');
                } else {
                  controllerRecord.stop(canceled: false);
                  debugPrint('play');
                }
              },
              songData: songModel,
              nowPlay: widget.nowPlay,
            ),
          ],
        ),
      ),
    );
  }
}
