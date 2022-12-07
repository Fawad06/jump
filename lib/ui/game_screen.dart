import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jump/generated/assets.dart';

import '../game_controller/game_controller.dart';

class GameView extends StatelessWidget {
  GameView({Key? key}) : super(key: key);
  final game = JumpGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent.withOpacity(0.8),
              Colors.greenAccent.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GameWidget(
          game: game,
          overlayBuilderMap: {
            'game_over': (context, JumpGame game) {
              return SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Text(
                      "Score: ${game.score}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                        color: Colors.cyan,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            iconSize: 72,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: SvgPicture.asset(Assets.iconsHomeButton),
                          ),
                          IconButton(
                            iconSize: 72,
                            onPressed: () {
                              game.restartGame();
                            },
                            icon: SvgPicture.asset(Assets.iconsPlayButton),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
