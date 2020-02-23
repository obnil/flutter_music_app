import 'package:flutter/material.dart';
import 'package:flutter_music_app/models/data_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/provider/provider_widget.dart';
import 'package:flutter_music_app/ui/page/albums_screen.dart';

class AlbumsCarousel extends StatelessWidget {
  final String input;
  AlbumsCarousel({this.input});
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Albums',
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
      ProviderWidget<SongListModel>(
          onModelReady: (model) async {
            await model.initData();
          },
          model: SongListModel(input: input),
          builder: (context, model, child) {
            return Container(
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.list.length,
                itemBuilder: (BuildContext context, int index) {
                  Data data = model.list[index];
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlbumsScreen(
                            data: data,
                          ),
                        ),
                      ),
                    },
                    child: Container(
                      width: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image(
                                  height: 120.0,
                                  width: 120.0,
                                  image: NetworkImage(data.pic),
                                  fit: BoxFit.cover,
                                ),
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
            );
          })
    ]);
  }
}
