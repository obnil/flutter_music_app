import 'package:flutter/material.dart';
import 'package:flutter_music_app/config/router_manager.dart';
// import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/helper/refresh_helper.dart';
import 'package:flutter_music_app/ui/page/player_screen.dart';
import 'package:flutter_music_app/ui/widget/article_skeleton.dart';
import 'package:flutter_music_app/ui/widget/skeleton.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AlbumsScreen extends StatefulWidget {
  final Data data;

  AlbumsScreen({this.data});
  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  Widget _buildSongItem(Data data,int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: 50,
              height: 50,
              color: Color(0xFFE8FFE2),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(color: Color(0xFF4FB926),),
                ),
              ),
            ),
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
                    style: TextStyle(
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
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
          Icon(Icons.favorite_border,size: 20.0,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ProviderWidget<SongListModel>(
          onModelReady: (model) async {
            await model.initData();
          },
          model: SongListModel(input: widget.data.author),
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
                var success =
                    await Navigator.of(context).pushNamed(RouteName.login);
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
                    return GestureDetector(
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlayScreen(
                                    data: data,
                                  ),
                                ),
                              ),
                            },
                        child: _buildSongItem(data,index+1));
                  }),
            );
          }),
    );
  }
}
