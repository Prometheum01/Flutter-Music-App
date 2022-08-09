import 'package:flutter/material.dart';
import 'package:music_app/pages/main_page.dart';
import 'package:music_app/utils/provider_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProviderManager.mainProvider,
        ProviderManager.audioProvider,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music App',
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.black, size: 18),
          textTheme: TextTheme(
            headline6: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            headline5: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            subtitle2: TextStyle(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        home: const MainPage(),
      ),
    );
  }
}
