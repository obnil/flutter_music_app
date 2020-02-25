import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/for_you_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/ui/page/player_screen.dart';
import 'package:provider/provider.dart';

class ForYouCarousel extends StatefulWidget {

  final ForYouModel forYouModel;

  ForYouCarousel(this.forYouModel);
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel> {
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
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('For you',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
            GestureDetector(
              onTap: () => {
                print('View All'),
              },
              child: Text('View All',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true, //解决无限高度问题
        physics: new NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.forYouModel.list.length,
        itemBuilder: (BuildContext context, int index) {
          Data data = widget.forYouModel.list[index];
          return GestureDetector(
            onTap: () {
              if (null != data.url) {
                SongModel songModel = Provider.of(context);
                songModel.setSongs(new List<Data>.from(widget.forYouModel.list));
                songModel.setCurrentIndex(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayScreen(
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
    ]);
  }
}
