import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:example/component/components.dart';
import 'package:example/component/ground_component.dart';
import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_widget.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/foundation.dart';
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

class AppGame extends Forge2DGame with FPSCounter, HasDraggableComponents {
  AppGame({
    required this.onAssetsLoad,
  });
  final FutureVoidCallback onAssetsLoad;
  late final GameCamera gameCamera = GameCamera(game: this);
  late final spritesCache = SpritesCache(game: this);
  Sprite getSprite(SpritesTitles title) => spritesCache.sprites[title]!;
  late YoungsterComponent com;
  bool isDragging = false;
  Vector2? dragStart;
  Vector2? lastDiff;
  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    camera
      ..worldBounds = const Rect.fromLTRB(0, 0, 20000, 1000)
      ..zoom =
          window.physicalSize.height / window.devicePixelRatio / canvasSize.y;
  }

  Rect get worldBounds => camera.worldBounds!;
  @override
  Future<void> onLoad() async {
    debugMode = true;
    await spritesCache.onLoad();
    // world.setGravity(Vector2(200, -10));
    await addAll(createBoundaries(this));
    final images = [
      await loadParallaxImage('bg_sky.png'),
      await loadParallaxImage('bg_trees.png'),
      await loadParallaxImage('bg_home.png'),
      await loadParallaxImage('bg_road_start.png'),
    ];
    final layers = images
        .map(
          (image) => ParallaxLayer(
            image,
            velocityMultiplier: Vector2(1.8, 0),
          )..resize(size),
        )
        .toList();

    final parallaxComponent = ParallaxComponent.fromParallax(
      Parallax(
        layers,
        // baseVelocity: Vector2(50, 0),
      ),
      priority: -1,
    );
    await add(parallaxComponent
        // await loadParallaxComponent(
        //   [
        //     ParallaxImageData('bg_road_start.png'),
        //     ParallaxImageData('bg_home.png'),
        //     ParallaxImageData('bg_trees.png'),
        //     ParallaxImageData('bg_sky.png'),

        //     // ParallaxImageData('bg.png'),
        //   ],
        //   priority: -1,
        //   // baseVelocity: Vector2(20, 0),
        //   velocityMultiplierDelta: Vector2(1.8, 0),
        //   alignment: Alignment.bottomCenter,
        // ),
        );

    // addContactCallback(WinContactCallback(game: this, onWin: () {}));
    // addContactCallback(KillingContactCallback(game: this, onKill: () {}));
    // addContactCallback(BounceContactCallback(game: this, onBounce: () {}));

    com = YoungsterComponent.create(
      game: this,
      position: Vector2(300, -700),
    );
    await add(com);
    // gameCamera.followComponent(com.positionComponent);
    final killingObstacle = KillingObstacleComponent.create(
      game: this,
      position: Vector2(350, -145),
    );
    await add(killingObstacle);
    killingObstacle.moveAlongPoints();
    // await add(
    //   YoungsterComponent(
    //     game: this,
    //     title: SpritesTitles.ghost,
    //     position: Vector2(400, -100),
    //     size: Vector2(100, 100),
    //   ),
    // );

    // await add(
    //   WinObstacleComponent.create(
    //     game: this,
    //     position: Vector2(500, -worldBottomY),
    //   ),
    // );
    // await add(
    //   CandyBagComponent.create(
    //     game: this,
    //     position: Vector2(500, -worldBottomY + 300),
    //   ),
    // );
    // await add(
    //   KillingObstacleComponent.create(
    //     game: this,
    //     position: Vector2(350, -145),
    //   ),
    // );
    await onAssetsLoad();
    await super.onLoad();
    gameCamera.initCameraPosition();
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    final shouldDragStart = !com.containsPoint(info.eventPosition.game);
    if (shouldDragStart) {
      dragStart = info.eventPosition.game;
      isDragging = true;
    }
    super.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo event) {
    if (isDragging && dragStart != null) {
      lastDiff = event.eventPosition.game - dragStart!;
      const moveCoeff = .5;
      final camPos = camera.position;
      final finalCamPos =
          Vector2(camPos.x - lastDiff!.x, camPos.y - lastDiff!.y);
      camera.snapTo(Vector2(
        camPos.x - lastDiff!.x * moveCoeff,
        camPos.y + lastDiff!.y * moveCoeff,
      ));
      dragStart = dragStart! + lastDiff!;
      log('cam: $camPos');
      log('final ${finalCamPos.toString()}');
    } else if (isDragging) {
      lastDiff = event.eventPosition.game - dragStart!;
    }
    super.onDragUpdate(pointerId, event);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo event) {
    isDragging = false;
    lastDiff = null;
    super.onDragEnd(pointerId, event);
  }
}
