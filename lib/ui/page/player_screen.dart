import 'dart:ui';

import 'package:flutter/material.dart';
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

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share), onPressed: () => {})
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 50.0),
                  ClipOval(
                    child: Container(
                      width: 200.0,
                      child: Image.network(widget.data.pic),
                    ),
                  ),
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
                    widget.data.title,
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    widget.data.author,
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
              new Player(
                onError: (e) {
                  Scaffold.of(context).showSnackBar(
                    new SnackBar(
                      content: new Text(e),
                    ),
                  );
                },
                onPrevious: () {},
                onNext: () {},
                onCompleted: () {},
                onPlaying: (isPlaying) {
                  if (isPlaying) {
                    print('pause');
                  } else {
                    print('play');
                  }
                },
                data: widget.data, songData: widget.songData,
              ),
            ],
          ),
        ));
  }
}
