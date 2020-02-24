import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/app_bar.dart';
import 'package:flutter_music_app/config/router_manager.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/helper/refresh_helper.dart';
import 'package:flutter_music_app/ui/page/player_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchScreen extends StatefulWidget {
  final String input;

  SearchScreen({this.input});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _buildSongItem(Data data) {
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: AppBarCarousel(),
          ),
          Container(
            margin: EdgeInsets.all(40),
            alignment: Alignment.center,
            child: Text('${widget.input}的搜索结果')),
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
                        error: model.viewStateError, onPressed: model.initData);
                  } else if (model.empty) {
                    return ViewStateEmptyWidget(onPressed: model.initData);
                  } else if (model.unAuthorized) {
                    return ViewStateUnAuthWidget(onPressed: () async {
                      var success = await Navigator.of(context)
                          .pushNamed(RouteName.login);
                      // 登录成功,获取数据,刷新页面
                      if (success ?? false) {
                        model.initData();
                      }
                    });
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
                          Data data = model.list[index];
                          model.setSongs(model.list);
                          return GestureDetector(
                              onTap: () {
                                if (null != data.url) {
                                  model.setCurrentIndex(index);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlayScreen(model, data,
                                          nowPlay: true),
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
    );
  }
}
