import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:jump/game_controller/game_components/line_controller.dart';
import 'package:jump/game_controller/game_components/mine_component.dart';
import 'package:jump/game_controller/game_controller.dart';

class BallComponent extends CircleComponent
    with CollisionCallbacks, HasGameRef<JumpGame> {
  final Vector2 location;
  late Vector2 targetPosition;
  LineComponent? currentAttachedLine;
  Vector2? nextIncrement;
  final VoidCallback gameOver;
  final VoidCallback lineJumped;
  late bool attachFromBack;

  BallComponent({
    required this.location,
    required this.gameOver,
    required this.lineJumped,
  }) : super(
          position: location,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    radius = gameRef.size.y * 0.025;
    add(CircleHitbox());
    add(
      SpriteComponent(
        sprite: await gameRef.loadSprite('football.png'),
        size: Vector2.all(gameRef.size.y * 0.025 * 2),
      ),
    );
  }

  @override
  void update(double dt) {
    if (checkIfOutOfBounds()) {
      gameOverCall();
    }
    if (currentAttachedLine != null) {
      position.setFrom(
        currentAttachedLine!.position +
            currentAttachedLine!.nextIncrement *
                gameRef.size.y *
                0.031 *
                (attachFromBack ? -1.0 : 1.0),
      );
    }
    if (nextIncrement != null) {
      position.setFrom(position + nextIncrement! * 6);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is LineComponent) {
      if (currentAttachedLine == null) {
        if (mag(position - other.position) >
            mag(position - (other.position + other.nextIncrement))) {
          attachFromBack = false;
        } else {
          attachFromBack = true;
        }
        lineJumped();
        currentAttachedLine = other;
        nextIncrement = null;
      } else if (nextIncrement == null) {
        gameOverCall();
      }
    }
    if (other is MineComponent) {
      gameOverCall();
    }
  }

  void onTap(TapDownInfo info) {
    if (nextIncrement == null && !gameRef.paused) {
      currentAttachedLine = null;
      targetPosition = info.eventPosition.game;
      Vector2 v1 = targetPosition - position;
      double a = atan2(v1.y, v1.x);
      nextIncrement = Vector2(cos(a), sin(a));
    }
  }

  double mag(Vector2 v) {
    double mag = sqrt((v.x * v.x) + (v.y * v.y));
    return mag;
  }

  bool checkIfOutOfBounds() {
    if (position.x >= gameRef.size.x ||
        position.y >= gameRef.size.y ||
        position.x < 0 ||
        position.y < 0) {
      return true;
    }
    return false;
  }

  void gameOverCall() {
    currentAttachedLine = null;
    nextIncrement = null;
    position.setFrom(gameRef.size / 2);
    gameOver();
  }
}
