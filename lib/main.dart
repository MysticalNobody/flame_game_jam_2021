import 'dart:math';

import 'package:example/component/components.dart';
import 'package:flame/game.dart';
import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'system/debug_system.dart';
import 'system/kawabunga_system.dart';
import 'system/move_system.dart';
import 'system/sprite_system.dart';

void main() {
  runApp(
    MaterialApp(
      home: GameWidget(
        game: ExampleGame(
          onAssetsLoad: () async {},
        ),
      ),
    ),
  );
}

typedef FutureVoidCallback = Future<void> Function();

class ExampleGame extends OxygenGame with FPSCounter {
  ExampleGame({
    required this.onAssetsLoad,
  });
  final FutureVoidCallback onAssetsLoad;

  @override
  Future<void> onLoad() async {
    await onAssetsLoad();
    return super.onLoad();
  }

  @override
  Future<void> init() async {
    if (kDebugMode) {
      world.registerSystem(DebugSystem());
    }
    world.registerSystem(MoveSystem());
    world.registerSystem(SpriteSystem());
    world.registerSystem(KawabungaSystem());

    world.registerComponent<TimerComponent, double>(() => TimerComponent());
    world.registerComponent<VelocityComponent, Vector2>(
      () => VelocityComponent(),
    );

    final random = Random();
    for (var i = 0; i < 10; i++) {
      createEntity(
        name: 'Entity $i',
        position: size / 2,
        size: Vector2.all(64),
        angle: 0,
      )
        ..add<SpriteComponent, SpriteInit>(
          SpriteInit(await loadSprite('pizza.png')),
        )
        ..add<VelocityComponent, Vector2>(
          Vector2(
            random.nextDouble() * 100 * (random.nextBool() ? 1 : -1),
            random.nextDouble() * 100 * (random.nextBool() ? 1 : -1),
          ),
        );
    }
  }
}
