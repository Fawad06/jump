import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class GameView extends StatelessWidget {
  GameView({Key? key}) : super(key: key);
  final game = JumpGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}

class JumpGame extends Forge2DGame with TapDetector {
  late final LineComponent l1;
  late final LineComponent l2;
  late final LineComponent l3;
  late final LineComponent l4;

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final rand = Random();
    l1 = LineComponent(
      random: rand,
      location: size / 2,
      centerTile: true,
    );
    l2 = LineComponent(
      random: rand,
      location: Vector2(
        size.x * rand.nextDouble(),
        size.y * rand.nextDouble(),
      ),
    );
    l3 = LineComponent(
      random: rand,
      location: Vector2(
        size.x * rand.nextDouble(),
        size.y * rand.nextDouble(),
      ),
    );
    l4 = LineComponent(
      random: rand,
      location: Vector2(
        size.x * rand.nextDouble(),
        size.y * rand.nextDouble(),
      ),
    );
    add(l1);
    add(l2);
    add(l3);
    add(l4);
  }
}

class LineComponent extends BodyComponent {
  LineComponent({
    required this.random,
    required this.location,
    this.centerTile = false,
  }) : super(paint: Paint()..color = Colors.black);

  final Random random;
  final Vector2 location;
  final bool centerTile;
  late Vector2 targetPosition;
  double speed = 0;

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBoxXY(gameRef.size.y * 0.05, gameRef.size.y * 0.003);
    final fixture = FixtureDef(shape);
    final bodyDef = BodyDef(userData: this, position: location);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    targetPosition = centerTile
        ? Vector2(gameRef.size.x / 2, -10)
        : getNextTargetPosition(firstTime: true);
    speed = 0.1;
  }

  @override
  void update(double dt) {
    if (body.position.x.toInt() != targetPosition.x.toInt() ||
        body.position.y.toInt() != targetPosition.y.toInt()) {
      Vector2 v1 = targetPosition - body.position;
      double a = atan2(v1.y, v1.x);
      Vector2 nextPoint = Vector2(cos(a), sin(a));
      body.setTransform(body.position + nextPoint * 0.1, a - atan2(1, 0));
    }
    if (checkOutOfCanvasRange(body.position)) {
      targetPosition = getNextTargetPosition();
    }
  }

  bool checkOutOfCanvasRange(Vector2 pos) {
    final game = gameRef.size;
    if (pos.x >= game.x + 5 ||
        pos.y >= game.y + 5 ||
        pos.x <= 0 - 5 ||
        pos.y <= 0 - 5) {
      return true;
    }
    return false;
  }

  Vector2 getNextTargetPosition({bool firstTime = false}) {
    double x = 0, y = 0;
    if (random.nextBool()) {
      x = (gameRef.size.x * 0.2) +
          random.nextInt((gameRef.size.x * 0.6).toInt()).toDouble();
      y = random.nextBool() ? gameRef.size.y.toDouble() + 10 : -10;
    } else {
      y = (gameRef.size.x * 0.2) +
          random.nextInt((gameRef.size.y * 0.6).toInt()).toDouble();
      x = random.nextBool() ? gameRef.size.x.toDouble() + 10 : -10;
    }
    if (!firstTime) {
      if (body.position.x < 0 && x < 0) {
        x = gameRef.size.x + 10;
      }
      if (body.position.y < 0 && y < 0) {
        y = gameRef.size.y + 10;
      }
      if (body.position.x > 0 && x > 0) {
        x = -x;
      }
      if (body.position.x > 0 && x > 0) {
        y = -y;
      }
    }
    return Vector2(x, y);
  }
}
