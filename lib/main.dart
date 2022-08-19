import 'package:flutter/material.dart';
import 'package:music_player_app/src/models/audio_player_model.dart';
import 'package:music_player_app/src/screens/music_player_screen.dart';
import 'package:music_player_app/src/themes/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AudioplayerModel()),
      ],
      child: MaterialApp(
        title: 'Music Player App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.miTema,
        home: const MusicPlayerScreen(),
      ),
    );
  }
}
