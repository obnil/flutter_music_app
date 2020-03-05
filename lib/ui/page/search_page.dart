import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/helper/refresh_helper.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchPage extends StatefulWidget {
  final String input;

  SearchPage({this.input});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Widget _buildSongItem(Song data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
                width: 50, height: 50, child: Image.network(data.pic)),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.title,
                    style: data.url == null
                        ? TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          )
                        : TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.author,
                    style: data.url == null
                        ? TextStyle(
                            fontSize: 10.0,
                            color: Color(0xFFE0E0E0),
                          )
                        : TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
          data.url == null
              ? Icon(
                  Icons.favorite_border,
                  color: Color(0xFFE0E0E0),
                  size: 20.0,
                )
              : Icon(
                  Icons.favorite_border,
                  size: 20.0,
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBarCarousel(),
            Container(
                margin: EdgeInsets.only(bottom: 40),
                alignment: Alignment.center,
                child: Text(S.of(context).searchResult + widget.input)),
            Expanded(
              child: ProviderWidget<SongListModel>(
                  onModelReady: (model) async {
                    await model.initData();
                  },
                  model: SongListModel(input: widget.input),
                  builder: (context, model, child) {
                    if (model.busy) {
                      // return SkeletonList(
                      //   builder: (context, index) => ArticleSkeletonItem(),
                      // );
                      return Center(child: Text('加载中...'));
                    } else if (model.error && model.list.isEmpty) {
                      return ViewStateErrorWidget(
                          error: model.viewStateError,
                          onPressed: model.initData);
                    } else if (model.empty) {
                      return ViewStateEmptyWidget(onPressed: model.initData);
                    }
                    return SmartRefresher(
                      controller: model.refreshController,
                      header: WaterDropHeader(),
                      footer: RefresherFooter(),
                      onRefresh: () async {
                        await model.refresh();
                      },
                      onLoading: () async {
                        await model.loadMore();
                      },
                      enablePullUp: true,
                      child: ListView.builder(
                          itemCount: model.list.length,
                          itemBuilder: (context, index) {
                            Song data = model.list[index];
                            return GestureDetector(
                                onTap: () {
                                  if (null != data.url) {
                                    SongModel songModel = Provider.of(context);
                                    songModel.setSongs(model.list);
                                    songModel.setCurrentIndex(index);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PlayPage(nowPlay: true),
                                      ),
                                    );
                                  }
                                },
                                child: _buildSongItem(data));
                          }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
