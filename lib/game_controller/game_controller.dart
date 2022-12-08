import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jump/game_controller/game_components/mine_component.dart';
import 'package:jump/services/database_service.dart';

import 'game_components/ball_component.dart';
import 'game_components/line_controller.dart';

class JumpGame extends FlameGame with HasCollisionDetection, TapDetector {
  late final List<LineComponent> lines;
  late final BallComponent ball;
  late final MineComponent mine;
  late final Random rand;
  bool shouldPause = true;
  int score = 0;

  @override
  backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    rand = Random();
    ball = BallComponent(
      location: size / 2,
      lineJumped: () => score++,
      gameOver: gameOver,
    );
    mine = MineComponent(
      location: Vector2(size.x * 0.2, size.y * 0.1),
      ball: ball,
    );
    lines = List.generate(
      5,
      (index) => LineComponent(
        random: rand,
        gameSize: size,
        location: Vector2(
          size.x * rand.nextDouble(),
          size.y * rand.nextDouble(),
        ),
      ),
    );
    await Future.wait<void>([
      ...lines.map((e) => add(e)!),
      add(ball)!,
      add(mine)!,
    ]);

    Timer(const Duration(seconds: 3), () => resumeEngine());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (shouldPause) {
      pauseEngine();
      shouldPause = false;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    ball.onTap(info);
  }

  void gameOver() async {
    pauseEngine();
    overlays.add('game_over');
    if ((DatabaseService.pref.getInt('high_score') ?? 0) < score) {
      await DatabaseService.pref.setInt('high_score', score);
    }
  }

  void restartGame() {
    score = 0;
    overlays.remove('game_over');
    ball.position.setFrom(size / 2);
    mine.goingBoom = false;
    mine.position.setFrom(Vector2(size.x * 0.2, size.y * 0.1));
    for (var element in lines) {
      element.position.setFrom(
        Vector2(
          size.x * rand.nextDouble(),
          size.y * rand.nextDouble(),
        ),
      );
    }
    resumeEngine();
  }
}
