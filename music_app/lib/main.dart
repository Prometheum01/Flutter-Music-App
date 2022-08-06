import 'package:flutter/material.dart';
import 'package:music_app/pages/main_page.dart';
import 'package:provider/provider.dart';

import 'providers/audio_player_provider.dart';
import 'providers/main_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AudioProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music App',
        theme: ThemeData(),
        home: const MainPage(),
      ),
    );
  }
}
