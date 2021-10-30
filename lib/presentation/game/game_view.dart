import 'dart:math' as math;

import 'package:example/component/components.dart';
import 'package:example/systems/systems.dart';
import 'package:example/utils/typedefs.dart';
import 'package:flame/game.dart';
import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppGameView extends StatefulWidget {
  const AppGameView({
    required this.game,
    Key? key,
  }) : super(key: key);
  final Game game;

  @override
  _AppGameViewState createState() => _AppGameViewState();
}

class _AppGameViewState extends State<AppGameView> {
  @override
  Widget build(BuildContext context) {
    return GameWidget(game: widget.game);
  }
}

class AppGame extends OxygenGame with FPSCounter {
  AppGame({
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

    final random = math.Random();
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
