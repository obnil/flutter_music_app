import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/config/router_manager.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/page/tab/home_page.dart';

class TabNavigator extends StatefulWidget {
  TabNavigator({Key key}) : super(key: key);

  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  var _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> pages = <Widget>[HomePage(), HomePage(), HomePage(), HomePage()];

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SongListModel>(
        onModelReady: (model) async {
          await model.initData();
        },
        model: SongListModel(input: '钢琴曲'),
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
          model.setSongs(model.list);
          return Scaffold(
            body: PageView.builder(
              itemBuilder: (ctx, index) => pages[index],
              itemCount: pages.length,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: BubbleBottomBar(
                currentIndex: _selectedIndex,
                backgroundColor: Colors.transparent,
                onTap: (int index) {
                  _pageController.jumpToPage(index);
                },
                items: <BubbleBottomBarItem>[
                  BubbleBottomBarItem(
                    backgroundColor: Color(0xFFF19A69),
                    icon: Icon(
                      Icons.search,
                      size: 25.0,
                    ),
                    activeIcon: Icon(
                      Icons.search,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      S.of(context).tabSearch,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BubbleBottomBarItem(
                    backgroundColor: Color(0xFFF19A69),
                    icon: Icon(
                      Icons.music_note,
                      size: 25.0,
                    ),
                    activeIcon: Icon(
                      Icons.music_note,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      S.of(context).tabMusic,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BubbleBottomBarItem(
                    backgroundColor: Color(0xFFF19A69),
                    icon: Icon(
                      Icons.favorite,
                      size: 25.0,
                    ),
                    activeIcon: Icon(
                      Icons.favorite,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      S.of(context).tabFavorite,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  BubbleBottomBarItem(
                    backgroundColor: Color(0xFFF19A69),
                    icon: Icon(
                      Icons.person,
                      size: 25.0,
                    ),
                    activeIcon: Icon(
                      Icons.person,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      S.of(context).tabUser,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                opacity: 1,
                elevation: 0,
              ),
            ),
          );
        });
  }
}
