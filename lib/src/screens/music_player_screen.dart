import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player_app/src/helpers/helpers.dart';
import 'package:music_player_app/src/models/audio_player_model.dart';
import 'package:provider/provider.dart';

class MusicPlayerScreen extends StatelessWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.chevronLeft),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.message)),
            IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.headphonesSimple)),
            IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.upRightFromSquare)),
          ]),
      body: Stack(
        children: [
          const _BackgroundPlayer(),
          Column(
            children: const [
              _DiscImageAndDuration(),
              _TitlePlay(),
              Expanded(child: _Lyrics()),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundPlayer extends StatelessWidget {
  const _BackgroundPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.8,
      width: double.maxFinite,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.center,
            colors: [
              Color(0xFF33333E),
              Color(0xFF201E28),
            ],
          )),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListWheelScrollView(
        physics: const BouncingScrollPhysics(),
        diameterRatio: 2.7,
        itemExtent: 60,
        children: Helpers.getLyrics()
            .map((line) => Text(
                  line,
                  style: const TextStyle(fontSize: 20, color: Colors.white60),
                  textAlign: TextAlign.center,
                ))
            .toList(),
      ),
    );
  }
}

class _TitlePlay extends StatefulWidget {
  const _TitlePlay({
    Key? key,
  }) : super(key: key);

  @override
  State<_TitlePlay> createState() => _TitlePlayState();
}

class _TitlePlayState extends State<_TitlePlay> with SingleTickerProviderStateMixin {
  bool firstTime = true;
  AnimationController? playAnimation;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioplayerModel>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 20),
      child: Row(children: [
        Column(
          children: const [
            Text('BZRP Music Sessions #52', style: TextStyle(fontSize: 22, color: Colors.white70)),
            Text('Bizarrap Ft. Quevedo', style: TextStyle(fontSize: 15, color: Colors.white38)),
          ],
        ),
        const Spacer(),
        FloatingActionButton(
            onPressed: () async {
              if (audioPlayerModel.isPlaying) {
                playAnimation?.reverse();
                audioPlayerModel.isPlaying = false;
                audioPlayerModel.controller?.stop();
              } else {
                playAnimation?.forward();
                audioPlayerModel.isPlaying = true;
                audioPlayerModel.controller?.repeat();
              }

              if (firstTime) {
                await openAsset();
                firstTime = false;
              } else {
                assetsAudioPlayer.playOrPause();
              }
            },
            backgroundColor: const Color(0xFFF8CB51),
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnimation!,
            ))
      ]),
    );
  }

  @override
  void dispose() {
    playAnimation?.dispose();
    super.dispose();
  }

  Future<void> openAsset() async {
    final audioPlayerModel = Provider.of<AudioplayerModel>(context, listen: false);
    await assetsAudioPlayer.open(Audio('assets/Bzrp-Music-Sessions-Vol-52.mp3'), autoStart: true, showNotification: true);
    audioPlayerModel.songDuration = assetsAudioPlayer.current.value?.audio.duration ?? const Duration(milliseconds: 0);

    assetsAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.currentDuration = duration;
      if (audioPlayerModel.songDuration == duration) {
        audioPlayerModel.reset();
      }
    });
  }
}

class _DiscImageAndDuration extends StatelessWidget {
  const _DiscImageAndDuration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(top: 100),
      child: Row(
        children: const [
          _DiscImage(),
          Spacer(),
          _ProgressBar(),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioplayerModel>(context);

    return Column(
      children: [
        Text(audioPlayerModel.songTotalDuration, style: const TextStyle(color: Colors.white38)),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 230),
          child: RotatedBox(
            quarterTurns: -1,
            child: LinearProgressIndicator(
              value: audioPlayerModel.percentage,
              color: Colors.white,
            ),
          ),
        ),
        Text(audioPlayerModel.currentSeconds, style: const TextStyle(color: Colors.white38)),
      ],
    );
  }
}

class _DiscImage extends StatelessWidget {
  const _DiscImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioplayerModel>(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      width: 250,
      height: 250,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xFF484750),
            Color(0xFF1E1C24),
          ],
        ),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              animate: false,
              duration: const Duration(seconds: 8),
              manualTrigger: true,
              infinite: true,
              controller: (animController) => audioPlayerModel.controller = animController,
              child: Image.asset(
                'assets/album-cover.jpg',
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
              child: const Icon(
                Icons.brightness_1,
                color: Colors.black,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
