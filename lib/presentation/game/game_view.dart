import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:example/component/camera_mover_component.dart';
import 'package:example/component/components.dart';
import 'package:example/component/ground_component.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:just_audio/just_audio.dart';

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
  // final player = AudioPlayer();
  @override
  void initState() {
    play();
    super.initState();
  }

  Future<void> play() async {
    // await player.setAsset('assets/audio/pixies-where-is-my-mind.mp3');
    // await player.play();
  }

  @override
  void dispose() {
    // player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppGameWidget(game: widget.game);
  }
}

class AppGame extends Forge2DGame
    with FPSCounter, HasDraggableComponents, MultiTouchDragDetector {
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

    final bg = getSprite(SpritesTitles.bg);
    setAspectRatio();
    final deviceHeight = window.physicalSize.height / window.devicePixelRatio;
    final worldSize = Vector2(bg.srcSize.x, bg.srcSize.y) * aspectRatio;
    camera
      ..worldBounds = worldSize.toRect()
      ..zoom = deviceHeight / (bg.srcSize.y * aspectRatio);
    await addAll(createBoundaries(this));

    addContactCallback(WinContactCallback(game: this, onWin: () {}));
    addContactCallback(KillingContactCallback(game: this, onKill: () {}));
    addContactCallback(BounceContactCallback(game: this, onBounce: () {}));
    await add(BackgroundComponent(worldSize, bg));
    await add(
      YoungsterComponent(
        game: this,
        title: SpritesTitles.ghost,
        position: Vector2(700, -225),
        size: Vector2(100, 100),
      ),
    );

    await add(BackgroundComponent(worldSize, bg));
    await add(
      YoungsterComponent(
        game: this,
        title: SpritesTitles.ghost,
        position: Vector2(400, -100),
        size: Vector2(100, 100),
      ),
    );

    await add(
      WinObstacleComponent.create(
        game: this,
        position: Vector2(500, -worldBottomY),
      ),
    );
    await add(
      CandyBagComponent.create(
        game: this,
        position: Vector2(500, -worldBottomY + 300),
      ),
    );
    await add(
      KillingObstacleComponent.create(
        game: this,
        position: Vector2(350, -145),
      ),
    );
    await onAssetsLoad();
    await super.onLoad();
    final camComponent = CameraMoverComponent(gameCamera);
    await add(camComponent);
    gameCamera.initCameraPosition();
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    log(info.eventPosition.game.toString());
    super.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo event) {
    gameCamera.position = event.eventPosition.game;
    log(event.eventPosition.game.toString());
    super.onDragUpdate(pointerId, event);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo event) {
    super.onDragEnd(pointerId, event);
  }

  @override
  void onDragCancel(int pointerId) {
    super.onDragCancel(pointerId);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameCamera.velocity.isZero()) {
      gameCamera.position.add(gameCamera.velocity * dt * 10);
    }
  }
}
