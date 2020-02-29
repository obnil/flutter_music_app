import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/albums_model.dart';
import 'package:flutter_music_app/model/for_you_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/widget/albums_carousel.dart';
import 'package:flutter_music_app/anims/record_anim.dart';
import 'package:flutter_music_app/ui/widget/for_you_carousel.dart';
import 'package:flutter_music_app/ui/page/search_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _inputController = TextEditingController();
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  static const albumValueList = ['酒吧', '怀旧', '女歌手', '经典', '热门'];
  static const forYouValueList = ['华语', '流行', '轻音乐', '排行榜', '抖音'];

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
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
    _inputController.dispose();
    controllerRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SongModel songModel = Provider.of(context);
    Random r = new Random();
    int _randomSongAlbum = r.nextInt(albumValueList.length);
    int _randomSongForYou = r.nextInt(forYouValueList.length);
    if (songModel.isPlaying) {
      controllerRecord.forward();
    } else {
      controllerRecord.stop(canceled: false);
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: ProviderWidget2<AlbumsModel, ForYouModel>(
            onModelReady: (alubumsModel, forYouModel) async {
              await alubumsModel.initData();
              await forYouModel.initData();
            },
            model1: AlbumsModel(input: albumValueList[_randomSongAlbum]),
            model2: ForYouModel(input: forYouValueList[_randomSongForYou]),
            autoDispose: false,
            builder: (context, alubumsModel, forYouModel, child) {
              if (alubumsModel.busy) {
                return ViewStateBusyWidget();
              } else if (alubumsModel.error && alubumsModel.list.isEmpty) {
                return ViewStateErrorWidget(
                    error: alubumsModel.viewStateError,
                    onPressed: alubumsModel.initData);
              }
              return Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor.withAlpha(10),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: TextField(
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              controller: _inputController,
                              onChanged: (value) {},
                              onSubmitted: (value) {
                                if (value.isNotEmpty == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SearchPage(
                                        input: value,
                                      ),
                                    ),
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  hintText: songModel.songs != null
                                      ? songModel.currentSong.title
                                      : S.of(context).searchSuggest),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RotateRecord(
                          animation: _commonTween.animate(controllerRecord)),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(children: <Widget>[
                    AlbumsCarousel(alubumsModel),
                    ForYouCarousel(forYouModel),
                  ]),
                )
              ]);
            }),
      ),
    );
  }
}
