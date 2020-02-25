import 'package:flutter_music_app/models/favorite_model.dart';
import 'package:flutter_music_app/models/local_view_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/models/theme_model.dart';
import 'package:provider/provider.dart';

List<SingleChildCloneableWidget> providers = [
  ...independentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildCloneableWidget> independentServices = [
  ChangeNotifierProvider<ThemeModel>(
    create: (context) => ThemeModel(),
  ),
  ChangeNotifierProvider<LocaleModel>(
    create: (context) => LocaleModel(),
  ),
  ChangeNotifierProvider<GlobalFavouriteStateModel>(
    create: (context) => GlobalFavouriteStateModel(),
  ),
  ChangeNotifierProvider<SongModel>(
    create: (context) => SongModel(),
  )
];

List<SingleChildCloneableWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];
