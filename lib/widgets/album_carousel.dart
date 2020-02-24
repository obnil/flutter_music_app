import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/ui/page/player_screen.dart';

class AlbumCarousel extends StatefulWidget {
  final String input;
  AlbumCarousel({this.input});
  @override
  _AlbumCarouselState createState() => _AlbumCarouselState();
}

class _AlbumCarouselState extends State<AlbumCarousel> {
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
    return ProviderWidget<SongListModel>(
        onModelReady: (model) async {
          await model.initData();
        },
        model: SongListModel(input: widget.input),
        builder: (context, model, child) {
          return Container(
            child: ListView.builder(
              shrinkWrap: true, //解决无限高度问题
              physics: new NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: model.list.length,
              itemBuilder: (BuildContext context, int index) {
                Data data = model.list[index];
                model.setSongs(model.list);
                return GestureDetector(
                  onTap: () {
                    if (null != data.url) {
                      model.setCurrentIndex(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayScreen(
                            model,
                            data,
                            nowPlay: true,
                          ),
                        ),
                      );
                    }
                  },
                  child: _buildSongItem(data),
                );
              },
            ),
          );
        });
  }
}
