import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/config/resource_manager.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/ui/page/player_screen.dart';
import 'package:provider/provider.dart';

class RotateRecord extends AnimatedWidget {
  RotateRecord({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    SongModel songModel = Provider.of(context);
    return ProviderWidget<SongListModel>(
        model: SongListModel(),
        onModelReady: (model) {},
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayScreen(
                    nowPlay: false,
                  ),
                ),
              ),
            },
            child: new Container(
              height: 45.0,
              width: 45.0,
              child: new RotationTransition(
                  turns: animation,
                  child: new Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(songModel.songs!=null?songModel.currentSong.pic:ImageHelper.randomUrl()),
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}
