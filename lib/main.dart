import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../views/games_page.dart';
import 'models/business.dart';
import 'models/event.dart';
import 'models/game.dart';
import 'models/player.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Game>(GameAdapter());
  Hive.registerAdapter<Event>(EventAdapter());
  Hive.registerAdapter<EventType>(EventTypeAdapter());
  Hive.registerAdapter<Player>(PlayerAdapter());
  Hive.registerAdapter<PlayerColor>(PlayerColorAdapter());
  Hive.registerAdapter<Business>(BusinessAdapter());
  Hive.registerAdapter<ShopType>(ShopTypeAdapter());
  await Hive.openBox<Game>('games');
  if (Platform.isWindows) {
    await DesktopWindow.setMinWindowSize(const Size(800, 1000));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chinatown Banker',
        theme: ThemeData(primarySwatch: Colors.red),
        home: const GamesPage());
  }
}
