import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music_app/album_carousel.dart';
import 'package:flutter_music_app/app_bar.dart';
import 'package:flutter_music_app/config/router_manager.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/provider/view_state_widget.dart';
import 'package:flutter_music_app/ui/helper/refresh_helper.dart';
import 'package:flutter_music_app/ui/page/player_screen.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AlbumsScreen extends StatefulWidget {
  final Data data;

  AlbumsScreen({this.data});
  @override
  _AlbumsScreenState createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  Widget _buildSongItem(Data data, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: 50,
              height: 50,
              color: Theme.of(context).primaryColor.withAlpha(30),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
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
        Expanded(
          child: ListView(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                      width: 200,
                      height: 200,
                      child: Image.network(widget.data.pic))),
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  widget.data.title,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  widget.data.author,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
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
                          Text(
                            'Play',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
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
    ));
  }
}
