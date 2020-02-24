import 'package:flutter/material.dart';
import 'package:flutter_music_app/widgets/albums_carousel.dart';
import 'package:flutter_music_app/anims/record_anim.dart';
import 'package:flutter_music_app/widgets/for_you_carousel.dart';
import 'package:flutter_music_app/ui/page/search_screen.dart';

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
    return Scaffold(
        body: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 40.0,bottom: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withAlpha(10),
                    borderRadius: BorderRadius.circular(30.0),
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.black12,
                    //       offset: Offset(0, 1),
                    //       blurRadius: 10)
                    // ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:5.0),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                      controller: _inputController,
                      onChanged: (value) {},
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SearchScreen(
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
                          hintText: 'Track,album,artist,podcast'),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child:
                  RotateRecord(animation: _commonTween.animate(controllerRecord)),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(children: <Widget>[
          AlbumsCarousel(input: '热门'),
          ForYouCarousel(input: '精选'),
        ]),
      ),
    ]));
  }
}
