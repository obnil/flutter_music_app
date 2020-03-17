import 'package:flutter/material.dart';
import 'package:flutter_music_app/ui/widget/album_carousel.dart';
import 'package:flutter_music_app/ui/widget/app_bar.dart';
import 'package:flutter_music_app/model/song_model.dart';

class AlbumsPage extends StatefulWidget {
  final Song data;

  AlbumsPage({this.data});
  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          AppBarCarousel(),
          Expanded(
            child: ListView(
              children: <Widget>[
                Center(
                    child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(child: Image.network(widget.data.pic))),
                )),
                SizedBox(height: 20.0),
                Center(
                  child: Text(
                    widget.data.author,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 70,
                        margin: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.play_arrow,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Play',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 70,
                        margin: EdgeInsets.only(
                            top: 20, bottom: 20, left: 10, right: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.add),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Add'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AlbumCarousel(input: widget.data.author),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
