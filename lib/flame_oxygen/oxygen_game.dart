import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:oxygen/oxygen.dart';

import 'component.dart';
import 'flame_world.dart';

/// This is an Oxygen based implementation of [Game].
///
/// [OxygenGame] should be extended to add your own game logic.
///
/// It is based on the Oxygen package.
abstract class OxygenGame extends Forge2DGame with Loadable {
  late final FlameWorld oxygenWorld;

  OxygenGame() {
    oxygenWorld = FlameWorld(this);
  }

  /// Create a new [Entity].
  Entity createEntity({
    String? name,
    required Vector2 position,
    required Vector2 size,
    double? angle,
    Anchor? anchor,
    bool flipX = false,
    bool flipY = false,
  }) {
    final entity = oxygenWorld.entityManager.createEntity(name)
      ..add<PositionComponent, Vector2>(position)
      ..add<SizeComponent, Vector2>(size)
      ..add<AnchorComponent, Anchor>(anchor)
      ..add<AngleComponent, double>(angle)
      ..add<FlipComponent, FlipInit>(FlipInit(flipX: flipX, flipY: flipY));
    return entity;
  }

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    await super.onLoad();

    // Registering default components.
    oxygenWorld
        .registerComponent<SizeComponent, Vector2>(() => SizeComponent());
    oxygenWorld.registerComponent<PositionComponent, Vector2>(
      () => PositionComponent(),
    );
    oxygenWorld
        .registerComponent<AngleComponent, double>(() => AngleComponent());
    oxygenWorld
        .registerComponent<AnchorComponent, Anchor>(() => AnchorComponent());
    oxygenWorld.registerComponent<SpriteComponent, SpriteInit>(
      () => SpriteComponent(),
    );
    oxygenWorld
        .registerComponent<TextComponent, TextInit>(() => TextComponent());
    oxygenWorld
        .registerComponent<FlipComponent, FlipInit>(() => FlipComponent());

    await init();
    oxygenWorld.init();
  }

  /// Initialize the game and world.
  Future<void> init();

  @override
  @mustCallSuper
  void render(Canvas canvas) => oxygenWorld.render(canvas);

  @override
  @mustCallSuper
  void update(double delta) => oxygenWorld.update(delta);
}
