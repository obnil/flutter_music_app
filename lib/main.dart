import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/albums_carousel.dart';
import 'package:flutter_music_app/anims/record_anim.dart';
import 'package:flutter_music_app/for_you_carousel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color(0xFFFF9E68),
        primaryColorDark: Color(0xFF9A9998),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController controllerRecord;
  Animation<double> animationRecord;
  final _inputController = TextEditingController();
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  int _currentTab = 0;

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
    return Scaffold(
      body: SafeArea(
          child: ListView(children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(10.0),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.black12,
                      //       offset: Offset(0, 1),
                      //       blurRadius: 5)
                      // ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: TextField(
                          style: TextStyle(fontSize: 15.0,color: Colors.grey,),
                          controller: _inputController,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search,color: Colors.grey,),
                              hintText: 'Track,album,artist,podcast'),
                        ),
                      ),
                    )),
              ),
              RotateRecord(
                  inputController: _inputController,
                  animation: _commonTween.animate(controllerRecord)),
            ],
          ),
        ),
        AlbumsCarousel(input: '热门'),
        ForYouCarousel(input: '精选'),
      ])),
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
          currentIndex: _currentTab,
          backgroundColor: Colors.transparent,
          onTap: (int value) {
            setState(() {
              _currentTab = value;
            });
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
              title: Text('Search',style: TextStyle(color: Colors.white),),
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
              title: Text('Music',style: TextStyle(color: Colors.white),),
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
              title: Text('Favorite',style: TextStyle(color: Colors.white),),
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
              title: Text('Person',style: TextStyle(color: Colors.white),),
            ),
          ],
          opacity: 1,
          elevation: 0,
        ),
      ),
    );
  }
}
