import 'package:example/component/components.dart';
import 'package:example/component/ground_component.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_widget.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
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
  late final spritesCache = SpritesCache(game: this);
  Sprite getSprite(SpritesTitles title) => spritesCache.sprites[title]!;
  double aspectRatio = 1.0;

  void setAspectRatio() => aspectRatio = size.x / size.y;

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    setAspectRatio();
  }

  Rect get worldBounds => camera.worldBounds!;
  double get worldBottomY => worldBounds.bottom - 100;
  @override
  Future<void> onLoad() async {
    await spritesCache.onLoad();

    gameCamera.followPosition();
    final bg = getSprite(SpritesTitles.bg);

    final worldSize = Vector2(bg.srcSize.x, bg.srcSize.y) * aspectRatio;

    camera
      ..worldBounds = worldSize.toRect()
      ..zoom = 0.8;

    await add(BackgroundComponent(worldSize, bg));

    await add(
      FixtureComponent.createWall(
        game: this,
        position: Vector2(600, -worldBottomY),
      ),
    );
    await add(
      FixtureComponent.createCandyBag(
        game: this,
        position: Vector2(500, -worldBottomY),
      ),
    );
    await add(
      FixtureComponent.createGhost(
        game: this,
        position: Vector2(300, -100),
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
