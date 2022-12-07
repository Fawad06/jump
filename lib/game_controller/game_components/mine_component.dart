import 'dart:async' as asc;
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:jump/game_controller/game_components/ball_component.dart';
import 'package:jump/game_controller/game_components/line_controller.dart';

import '../game_controller.dart';

class MineComponent extends CircleComponent
    with CollisionCallbacks, HasGameRef<JumpGame> {
  final Vector2 location;
  final BallComponent ball;
  late Vector2 nextIncrement;
  bool goingBoom = true;

  MineComponent({required this.ball, required this.location})
      : super(
          position: location,
          anchor: Anchor.center,
          paint: Paint()..color = Colors.transparent,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    radius = gameRef.size.y * 0.03;
    Vector2 v1 = ball.position - position;
    double a = atan2(v1.y, v1.x);
    nextIncrement = Vector2(cos(a), sin(a));
    add(CircleHitbox());
    add(
      SpriteComponent(
        size: Vector2.all(gameRef.size.y * 0.03 * 2),
        sprite: await gameRef.loadSprite('floating_mine.png'),
      ),
    );
    asc.Timer.periodic(
      const Duration(seconds: 10),
      (timer) {
        if (!goingBoom && !gameRef.paused) {
          position.setFrom(Vector2(gameRef.size.x * 0.2, gameRef.size.y * 0.1));
          asc.Timer(const Duration(seconds: 3), () => goingBoom = true);
        }
      },
    );
  }

  @override
  void update(double dt) {
    if (goingBoom) {
      position.setFrom(position + nextIncrement * 8);
      Vector2 v1 = ball.position - position;
      double a = atan2(v1.y, v1.x);
      nextIncrement = Vector2(cos(a), sin(a));
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BallComponent) {
      goingBoom = false;
      position.setFrom(Vector2(-100, -100));
    }
    if (other is LineComponent) {
      goingBoom = false;
      position.setFrom(Vector2(-100, -100));
    }
  }
}
