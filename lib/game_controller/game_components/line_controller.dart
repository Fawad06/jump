import 'dart:async' as asc;
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'mine_component.dart';

class LineComponent extends RectangleComponent with CollisionCallbacks {
  final Random random;
  final Vector2 gameSize;
  final Vector2 location;
  late Vector2 targetPosition;
  late Vector2 nextIncrement;

  LineComponent({
    required this.random,
    required this.location,
    required this.gameSize,
  }) : super(
          position: location,
          anchor: Anchor.center,
          size: Vector2(gameSize.y * 0.1, gameSize.y * 0.01),
          paint: Paint()
            ..style = PaintingStyle.fill
            ..color = Colors.black,
        );

  bool isTargetNeeded = true;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(RectangleHitbox());
    targetPosition = getNextTargetPosition(firstTime: true);
    Vector2 v1 = targetPosition - position;
    double a = atan2(v1.y, v1.x);
    angle = a - atan2(1, 0);
    nextIncrement = Vector2(cos(a), sin(a));
  }

  @override
  void update(double dt) {
    if (nextIncrement.x != 0 && nextIncrement.y != 0) {
      position.setFrom(position + nextIncrement);
    }

    if (checkOutOfCanvasRange(position) && isTargetNeeded) {
      targetPosition = getNextTargetPosition();
      Vector2 v1 = targetPosition - position;
      double a = atan2(v1.y, v1.x);
      angle = a - atan2(1, 0);
      nextIncrement = Vector2(cos(a), sin(a));
      isTargetNeeded = false;
      asc.Timer(const Duration(seconds: 1), () {
        isTargetNeeded = true;
      });
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is LineComponent) {
      position.setFrom(getNextLinePosition());
    } else if (other is MineComponent) {
      position.setFrom(getNextLinePosition());
    }
  }

  bool checkOutOfCanvasRange(Vector2 pos) {
    if (pos.x >= gameSize.x + 40 ||
        pos.y >= gameSize.y + 40 ||
        pos.x <= 0 - 40 ||
        pos.y <= 0 - 40) {
      return true;
    }
    return false;
  }

  Vector2 getNextTargetPosition({bool firstTime = false}) {
    double x = 0, y = 0;
    if (random.nextBool()) {
      final minX = gameSize.x * 0.4;
      final maxX = gameSize.x * 0.6;
      x = minX + random.nextInt((maxX - minX).toInt()).toDouble();
      y = random.nextBool() ? gameSize.y.toDouble() + 50 : -50;
    } else {
      final minY = gameSize.y * 0.3;
      final maxY = gameSize.y * 0.6;
      y = minY + random.nextInt((maxY - minY).toInt()).toDouble();
      x = random.nextBool() ? gameSize.x.toDouble() + 50 : -50;
    }
    if (!firstTime) {
      if (position.x < 0 && x < 0) {
        x = gameSize.x + 50;
      }
      if (position.y < 0 && y < 0) {
        y = gameSize.y + 50;
      }
      if (position.x > gameSize.x + 50 && x > gameSize.x + 50) {
        x = -50;
      }
      if (position.y > gameSize.y + 50 && y > gameSize.y + 50) {
        y = -50;
      }
    }
    return Vector2(x, y);
  }

  Vector2 getNextLinePosition() {
    double x = 0, y = 0;
    if (random.nextBool()) {
      final minX = gameSize.x * 0.4;
      final maxX = gameSize.x * 0.6;
      x = minX + random.nextInt((maxX - minX).toInt()).toDouble();
      y = random.nextBool() ? gameSize.y.toDouble() + 50 : -50;
    } else {
      final minY = gameSize.y * 0.3;
      final maxY = gameSize.y * 0.6;
      y = minY + random.nextInt((maxY - minY).toInt()).toDouble();
      x = random.nextBool() ? gameSize.x.toDouble() + 50 : -50;
    }

    if (position.x < 0 && targetPosition.x < 0) {
      targetPosition.x = gameSize.x + 50;
    }
    if (position.y < 0 && targetPosition.y < 0) {
      targetPosition.y = gameSize.y + 50;
    }
    if (position.x > gameSize.x + 50 && targetPosition.x > gameSize.x + 50) {
      targetPosition.x = -50;
    }
    if (position.y > gameSize.y + 50 && targetPosition.y > gameSize.y + 50) {
      targetPosition.y = -50;
    }
    return Vector2(x, y);
  }
}
