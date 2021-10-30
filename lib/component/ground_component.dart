import 'dart:ui';

import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:forge2d/forge2d.dart';

List<Wall> createBoundaries(Forge2DGame game) {
  final worldBounds = game.camera.worldBounds;
  final Vector2 topRight = worldBounds!.topRight.toVector2().clone();
  final Vector2 topLeft = worldBounds.topLeft.toVector2().clone();
  final Vector2 bottomLeft = worldBounds.bottomLeft.toVector2().clone();

  return [
    Wall(position: topLeft, length: worldBounds.bottom),
    Wall(position: topRight..sub(Vector2(0, 10)), length: worldBounds.bottom),
    Wall(
      position: -bottomLeft,
      length: worldBounds.right,
      direction: WallDirection.horizontal,
    ),
    Wall(
      position: topLeft,
      length: worldBounds.right,
      direction: WallDirection.horizontal,
    ),
  ];
}

enum WallDirection {
  horizontal,
  vertical,
}

class Wall extends BodyComponent {
  Wall({
    required this.length,
    required this.position,
    this.direction = WallDirection.vertical,
  });
  @override
  Paint paint = BasicPalette.white.paint();
  final Vector2 position;
  final double length;
  final WallDirection direction;
  EdgeShape createShape() {
    final shape = EdgeShape();
    switch (direction) {
      case WallDirection.horizontal:
        shape.set(Vector2.zero(), Vector2(length, 0));
        break;
      case WallDirection.vertical:
        shape.set(Vector2.zero(), -Vector2(0, length));
        break;
    }
    return shape;
  }

  @override
  Body createBody() {
    final shape = createShape();

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..friction = 0.3;

    final bodyDef = BodyDef()
      ..userData = this // To be able to determine object in collision
      ..position = position
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
