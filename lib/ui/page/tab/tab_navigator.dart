import 'package:audio_manager/audio_manager.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/ui/page/tab/favorite_page.dart';
import 'package:flutter_music_app/ui/page/tab/home_page.dart';
import 'package:provider/provider.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  var _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> pages = <Widget>[
    HomePage(),
    HomePage(),
    FavoritePage(),
    HomePage()
  ];

  @override
  void dispose() {
    super.dispose();
    AudioManager.instance.stop();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteModel favoriteModel = Provider.of(context);
    return Scaffold(
      body: ProviderWidget<FavoriteListModel>(
          onModelReady: (favoriteListModel) async {
            await favoriteListModel.initData();
          },
          model: FavoriteListModel(favoriteModel: favoriteModel),
          builder: (context, model, child) {
            return PageView.builder(
              itemBuilder: (ctx, index) => pages[index],
              itemCount: pages.length,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            );
          }),
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
              backgroundColor: Theme.of(context).primaryColorDark,
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
              backgroundColor: Theme.of(context).primaryColorDark,
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
              backgroundColor: Theme.of(context).primaryColorDark,
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
              backgroundColor: Theme.of(context).primaryColorDark,
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
  }
}
