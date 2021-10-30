import 'package:example/component/components.dart';
import 'package:example/component/enemy_component.dart';
import 'package:example/component/ground_component.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_widget.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    return AppGameWidget(game: widget.game);
  }
}

class AppGame extends Forge2DGame with KeyboardEvents, FPSCounter {
  AppGame({
    required this.onAssetsLoad,
  });
  final FutureVoidCallback onAssetsLoad;
  late final GameCamera gameCamera = GameCamera(game: this);
  @override
  Future<void> onLoad() async {
    // camera.worldBounds = GameCamera.worldBounds;
    gameCamera.followPosition();

    // this.remove(c);
    final bg = await loadSprite('bg.jpg');
    final enemy = await loadSprite('enemy.png');
    await add(BackgroundComponent(Vector2(size.x, size.y), bg));
    await add(
      EnemyComponent(
        enemy,
        Vector2(10, 10),
        Vector2(0, 20),
      ),
    );
    await addAll(createBoundaries(this));
    await onAssetsLoad();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameCamera.velocity.isZero()) {
      gameCamera.position.add(gameCamera.velocity * dt * 10);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    void moveAlong({required AxisDirection direction}) {
      if (isKeyDown) {
        gameCamera.moveAlong(direction);
      } else {
        gameCamera.stopMoveAlong();
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      moveAlong(direction: AxisDirection.left);
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      moveAlong(direction: AxisDirection.right);
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      moveAlong(direction: AxisDirection.up);
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      moveAlong(direction: AxisDirection.down);
    }
    return KeyEventResult.handled;
  }
}
