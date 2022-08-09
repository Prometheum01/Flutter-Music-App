import 'package:music_app/providers/audio_player_provider.dart';
import 'package:music_app/providers/main_provider.dart';
import 'package:provider/provider.dart';

class ProviderManager {
  static ChangeNotifierProvider<MainProvider> mainProvider =
      ChangeNotifierProvider(
    create: (context) => MainProvider(),
  );
  static ChangeNotifierProvider<AudioProvider> audioProvider =
      ChangeNotifierProvider(
    create: (context) => AudioProvider(),
  );
}
