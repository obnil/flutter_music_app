import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/app_bar.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/ui/page/player_carousel.dart';

class PlayScreen extends StatefulWidget {
  final SongListModel songData;
  final bool nowPlay;
  final Data data;

  PlayScreen(this.songData, this.data, {this.nowPlay});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  String title;
  String pic;
  String author;
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  @override
  initState() {
    super.initState();
    pic = widget.data.pic;
    title = widget.data.title;
    author = widget.data.author;
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
                          image: NetworkImage(pic),
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
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  author,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
            Player(
              onError: (e) {
                Scaffold.of(context).showSnackBar(
                  new SnackBar(
                    content: new Text(e),
                  ),
                );
              },
              onPrevious: (Data data) {
                setState(() {
                  pic = data.pic;
                  title = data.title;
                  author = data.author;
                });
              },
              onNext: (Data data) {
                setState(() {
                  pic = data.pic;
                  title = data.title;
                  author = data.author;
                });
              },
              onCompleted: (Data data) {
                setState(() {
                  pic = data.pic;
                  title = data.title;
                  author = data.author;
                });
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
              data: widget.data,
              songData: widget.songData,
            ),
          ],
        ),
      ),
    );
  }
}
