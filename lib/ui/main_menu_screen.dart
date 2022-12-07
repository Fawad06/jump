import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jump/services/database_service.dart';

import '../generated/assets.dart';
import 'game_screen.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({Key? key}) : super(key: key);

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent.withOpacity(0.1),
              Colors.cyanAccent.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 72,
                fontFamily: "Disko",
                color: Colors.cyan,
              ),
              child: AnimatedTextKit(
                isRepeatingAnimation: true,
                animatedTexts: [
                  WavyAnimatedText('Jump'),
                ],
              ),
            ),
            const Spacer(flex: 2),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => GameView(),
                  ),
                );
                setState(() {});
              },
              child: SvgPicture.asset(
                Assets.iconsPlayButton,
                width: 120,
                height: 120,
              ),
            ),
            const Spacer(flex: 2),
            Text(
              '"${DatabaseService.pref.getInt('high_score')}"',
              style: const TextStyle(
                fontSize: 34,
                fontFamily: "Disko",
              ),
            ),
            const Text(
              "High Score",
              style: TextStyle(
                fontSize: 34,
                fontFamily: "Disko",
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
