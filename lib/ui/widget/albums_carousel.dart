import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/albums_page.dart';

class AlbumsCarousel extends StatefulWidget {
  final List<Song> alubums;

  AlbumsCarousel(this.alubums);
  @override
  _AlbumsCarouselState createState() => _AlbumsCarouselState();
}

class _AlbumsCarouselState extends State<AlbumsCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(S.of(context).albums,
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
      Column(
        children: <Widget>[
          Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.alubums.length,
              itemBuilder: (BuildContext context, int index) {
                Song data = widget.alubums[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlbumsPage(
                          data: data,
                        ),
                      ),
                    ),
                  },
                  child: Container(
                    width: 140,
                    margin: index == widget.alubums.length - 1
                        ? EdgeInsets.only(right: 20.0)
                        : EdgeInsets.only(right: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image(
                              height: 120.0,
                              width: 120.0,
                              image: CachedNetworkImageProvider(data.pic),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    ]);
  }
}
