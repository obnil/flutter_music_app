import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/favorite_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:provider/provider.dart';

class ForYouCarousel extends StatefulWidget {
  final List<Song> forYou;

  ForYouCarousel(this.forYou);
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel> {
  Widget _buildSongItem(Song data) {
    FavoriteModel favoriteModel = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
                width: 50,
                height: 50,
                child: Image(image: CachedNetworkImageProvider(data.pic))),
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
                            color: Colors.grey,
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
                            color: Colors.grey,
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
          IconButton(
              onPressed: () => favoriteModel.collect(data),
              icon: data.url == null
                  ? Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 20.0,
                    )
                  : favoriteModel.isCollect(data)
                      ? Icon(
                          Icons.favorite,
                          color: Theme.of(context).accentColor,
                          size: 20.0,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 20.0,
                        ))
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
            Text(S.of(context).forYou,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
            GestureDetector(
              onTap: () => {
                print('View All'),
              },
              child: Text(S.of(context).viewAll,
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
        itemCount: widget.forYou.length,
        itemBuilder: (BuildContext context, int index) {
          Song data = widget.forYou[index];
          return GestureDetector(
            onTap: () {
              if (null != data.url) {
                SongModel songModel = Provider.of(context);
                songModel.setSongs(new List<Song>.from(widget.forYou));
                songModel.setCurrentIndex(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayPage(
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
