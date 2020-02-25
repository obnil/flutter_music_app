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
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    final Animation<double> animation = _commonTween.animate(controllerRecord);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                AppBarCarousel(),
                SizedBox(height: 50.0),
                RotationTransition(
                    turns: animation,
                    child: new Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(songModel.currentSong.pic),
                        ),
                      ),
                    )),
                SizedBox(height: 20.0),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          //widget.onPrevious();
                        },
                        icon: Icon(
                          Icons.menu,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //widget.onPrevious();
                        },
                        icon: Icon(
                          Icons.refresh,
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
                          Icons.volume_up,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      ),
                    ]),
                SizedBox(height: 20.0),
                Text(
                  songModel.currentSong.title,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                SizedBox(height: 20.0),
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
