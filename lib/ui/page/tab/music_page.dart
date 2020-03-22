import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/generated/i18n.dart';
import 'package:flutter_music_app/model/download_model.dart';
import 'package:flutter_music_app/model/song_model.dart';
import 'package:flutter_music_app/ui/page/player_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    final dir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = dir.listSync();
    for (var file in files) {
      print(file.path);
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
  Widget _buildSongItem(Song data) {
    DownloadModel downloadModel = Provider.of(context);
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
          IconButton(
              onPressed: () => downloadModel.download(data),
              icon: downloadModel.isDownload(data)
                  ? Icon(
                      Icons.cloud_done,
                      color: Theme.of(context).accentColor,
                      size: 20.0,
                    )
                  : Icon(
                      Icons.cloud_download,
                      size: 20.0,
                    ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    DownloadModel downloadModel = Provider.of(context);
    return Scaffold(
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(S.of(context).tabMusic,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
          ),
          Expanded(
              child: downloadModel.downloadSong.length == 0
                  ? Center(child: Text('none'))
                  : ListView.builder(
                      itemCount: downloadModel.downloadSong.length,
                      itemBuilder: (BuildContext context, int index) {
                        Song data = downloadModel.downloadSong[index];
                        return GestureDetector(
                          onTap: () {
                            if (null != data.url) {
                              SongModel songModel = Provider.of(context);
                              songModel.setSongs(new List<Song>.from(
                                  downloadModel.downloadSong));
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
                    ))
        ])));
  }
}
