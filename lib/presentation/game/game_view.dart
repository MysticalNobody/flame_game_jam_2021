import 'dart:async';
import 'dart:math';
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

  late ParallaxComponent parallaxCom;

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    camera.zoom =
        window.physicalSize.height / window.devicePixelRatio / canvasSize.y;
  }

  // late ParallaxComponent<AppGame> skyParallax;
  // late ParallaxComponent<AppGame> treesParallax;
  Future<ParallaxComponent<AppGame>> createParallaxComponent(
    String image,
  ) async {
    final images = [
      await loadParallaxImage(image),
    ];
    final layers = images
        .map(
          (image) =>
              ParallaxLayer(image, velocityMultiplier: Vector2(1.8, -1.8))
                ..resize(size),
        )
        .toList();

    return ParallaxComponent.fromParallax(
      Parallax(layers),
      priority: -1,
    );
  }

  Rect get worldBounds => camera.worldBounds!;
  @override
  Future<void> onLoad() async {
    debugMode = true;
    await spritesCache.onLoad();
    // world.setGravity(Vector2(200, -10));
    // skyParallax = await createParallaxComponent('bg_sky.png');
    // treesParallax = await createParallaxComponent('bg_trees.png');
    // await addAll([skyParallax, treesParallax]);

    final backSize = (await loadParallaxComponent(
      [
        ParallaxImageData('bg_road_start.png'), //1.44
        ParallaxImageData('bg_home.png'), //1.728
      ],
      priority: -1,
      repeat: ImageRepeat.noRepeat,
      velocityMultiplierDelta: Vector2(1, 0),
    )
          ..prepare(this))
        .parallax!
        .size;

    camera.worldBounds = Rect.fromLTRB(0, 0, backSize.x * 4, backSize.y * 1.2);
    await addAll(createBoundaries(this));
    await add(
      parallaxCom = await loadParallaxComponent(
        [
          ParallaxImageData('bg_sky.png'),
          ParallaxImageData('bg_trees.png'), //1.2
        ],
        priority: -1,
        velocityMultiplierDelta: Vector2(1.2, 0),
      ),
    );
    List<Sprite> homes = [
      getSprite(SpritesTitles.bgHome),
      getSprite(SpritesTitles.bgHome1),
      getSprite(SpritesTitles.bgHome2),
    ];
    final r = Random();
    for (int i = 0; i < 4; i++) {
      final backLeftTop = Vector2(
        worldBounds.left + i * backSize.x,
        worldBounds.bottom - backSize.y,
      );
      final home = BackgroundComponent(
        sprite: homes[r.nextInt(2)],
        size: backSize,
        position: backLeftTop,
      );
      final road = BackgroundComponent(
        sprite: i == 0
            ? getSprite(SpritesTitles.bgRoadStart)
            : getSprite(SpritesTitles.bgRoadMiddle),
        size: backSize,
        position: backLeftTop,
      );
      await addAll([home, road]);
    }

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
  void update(double dt) {
    super.update(dt);
    if (camera.position.x < 1) setZeroParallax();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo details) {
    if (isDragging && dragStart != null) {
      lastDiff = details.eventPosition.game - dragStart!;
      const moveCoeff = .5;
      final camPos = camera.position;
      final finalCamPos =
          Vector2(camPos.x - lastDiff!.x, camPos.y - lastDiff!.y);
      camera.snapTo(Vector2(
        camPos.x - lastDiff!.x * moveCoeff,
        camPos.y + lastDiff!.y * moveCoeff,
      ));
      dragStart = dragStart! + lastDiff!;
      if (camera.position.x > 1)
        parallaxCom.parallax!.baseVelocity.setFrom(-lastDiff! * 10);
    } else if (isDragging) {
      setZeroParallax();
      lastDiff = details.eventPosition.game - dragStart!;
    }
    super.onDragUpdate(pointerId, details);
  }

  void setZeroParallax() {
    parallaxCom.parallax!.baseVelocity.setFrom(Vector2.zero());
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo event) {
    setZeroParallax();
    isDragging = false;
    lastDiff = null;
    super.onDragEnd(pointerId, event);
  }
}
