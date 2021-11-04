part of components;

/// obstacle to bounce

/// obstacle to win

/// obstacle to lose

enum ObstacleType {
  bounce,
  win,
  lose,
}

class GhostData {
  // ignore: avoid_positional_boolean_parameters
  GhostData(this.name, [this.animated = false, this.count = 1]);
  String name = 'ghost1';
  int count = 1;
  bool animated = false;
  bool horMove = true;
  bool verMove = true;
}

final ghosts = <GhostData>[
  // GhostData('ghost1')..verMove = false,
  // GhostData('ghost2'),
  // GhostData('ghost3')
  //   ..horMove = false
  //   ..verMove = false,
  // GhostData('ghost4')..verMove = false,
  // GhostData('ghost5')..verMove = false,
  GhostData('temp1', true, 12)
    ..horMove = false
    ..verMove = false,
  GhostData('temp2', true, 16),
  GhostData('temp3', true, 16),
  GhostData('temp4', true, 16),
];

class PlayerContactCallback
    extends ContactCallback<FlyingCandyComponent, YoungsterComponent> {
  PlayerContactCallback({required this.game, required this.onContact});
  final widgets.ValueChanged<YoungsterComponent> onContact;
  final AppGame game;
  @override
  void begin(FlyingCandyComponent a, YoungsterComponent b, Contact contact) {
    log(b.body.toString());
    // onContact(b);
    b.candyKeeper.addCandy(a.title);
    game.remove(a);
  }

  @override
  void end(FlyingCandyComponent a, YoungsterComponent b, Contact contact) {}
}

class WinContactCallback
    extends ContactCallback<FlyingCandyComponent, WinObstacleComponent> {
  WinContactCallback({required this.game, required this.onWin});
  final widgets.VoidCallback onWin;
  final AppGame game;
  @override
  void begin(FlyingCandyComponent a, WinObstacleComponent b, Contact contact) {
    log(b.body.toString());
    b.candyKeeper.addCandy(a.title);
    game.remove(a);
    // if (b.candyKeeper.candies.length > game.initalCandyCount) {
    onWin();
    // }
  }

  @override
  void end(FlyingCandyComponent a, WinObstacleComponent b, Contact contact) {}
}

class KillingContactCallback
    extends ContactCallback<FlyingCandyComponent, KillingObstacleComponent> {
  KillingContactCallback({required this.game, required this.onKill});
  final widgets.VoidCallback onKill;
  final AppGame game;
  @override
  void begin(
    FlyingCandyComponent a,
    KillingObstacleComponent b,
    Contact contact,
  ) {
    log(b.body.toString());

    game.firstPlayer.candyKeeper.addCandy(a.title);
    game.remove(a);
    onKill();
  }

  @override
  void end(
    FlyingCandyComponent a,
    KillingObstacleComponent b,
    Contact contact,
  ) {}
}

class BounceContactCallback
    extends ContactCallback<FlyingCandyComponent, BounceContactCallback> {
  BounceContactCallback({required this.game, required this.onBounce});
  final widgets.VoidCallback onBounce;
  final AppGame game;
  @override
  void begin(FlyingCandyComponent a, BounceContactCallback b, Contact contact) {
    log(b.toString());
  }

  @override
  void end(
    FlyingCandyComponent a,
    BounceContactCallback b,
    Contact contact,
  ) {}
}

/// Like a door or another player
class WinObstacleComponent extends BaseObstacleComponent {
  WinObstacleComponent({
    required AppGame game,
    required Vector2 position,
    required Vector2 size,
    required Sprite sprite,
    BodyType type = BodyType.dynamic,
  }) : super(
          game: game,
          position: position,
          size: size,
          type: type,
          sprite: sprite,
        );
  static Future<WinObstacleComponent> create({
    required AppGame game,
    required Vector2 position,
  }) async =>
      WinObstacleComponent(
        game: game,
        sprite: await game.loadSprite('candy_bag.png'),
        position: position,
        type: BodyType.static,
        size: Vector2(100, 100),
      );

  late final candyKeeper = CandyKeeper(position: position, game: game);
}

/// Like a ghost
class KillingObstacleComponent extends BaseObstacleComponent {
  KillingObstacleComponent({
    required AppGame game,
    required Vector2 position,
    required Vector2 size,
    required Sprite sprite,
    GhostData? ghostData,
  }) : super(
          game: game,
          position: position,
          size: size,
          sprite: sprite,
          ghostData: ghostData,
        );
  KillingObstacleComponent.animated({
    required AppGame game,
    required List<Sprite> sprites,
    required double stepTime,
    required Vector2 position,
    required Vector2 size,
    BodyType type = BodyType.dynamic,
    GhostData? ghostData,
  }) : super.animated(
          game: game,
          position: position,
          size: size,
          type: type,
          sprites: sprites,
          stepTime: stepTime,
          ghostData: ghostData,
        );

  static Future<KillingObstacleComponent> create({
    required AppGame game,
    required Vector2 position,
  }) async {
    final r = math.Random();
    final data = ghosts[r.nextInt(ghosts.length)];
    if (data.animated) {
      final sprites = <Sprite>[];
      for (final index in List.generate(data.count, (index) => index + 1)) {
        sprites.add(await game.loadSprite('ghosts/${data.name}-$index.png'));
      }
      return KillingObstacleComponent.animated(
        game: game,
        position: position,
        size: Vector2(170, 240),
        stepTime: 0.1,
        sprites: sprites,
        ghostData: data,
      );
    }
    return KillingObstacleComponent(
      game: game,
      position: Vector2(position.x, game.bottomLine),
      size: Vector2(170, 240),
      sprite: await game.loadSprite('${data.name}.png'),
      ghostData: data,
    );
  }
}

/// Like a ghost
class BaseObstacleComponent extends AnimatedSpriteBodyComponent {
  BaseObstacleComponent({
    required this.game,
    required this.position,
    required Vector2 size,
    required Sprite sprite,
    this.ghostData,
    this.type = BodyType.dynamic,
  }) : super(
          SpriteAnimation.spriteList([sprite], stepTime: 1),
          size,
        );
  BaseObstacleComponent.animated({
    required List<Sprite> sprites,
    required double stepTime,
    required this.game,
    required this.position,
    required Vector2 size,
    this.ghostData,
    this.type = BodyType.dynamic,
  }) : super(SpriteAnimation.spriteList(sprites, stepTime: stepTime), size);
  GhostData? ghostData;
  final Vector2 position;
  final AppGame game;
  final BodyType type;

  async.Timer? timer;

  @override
  Future<void> onLoad() {
    moveAlongPoints();
    return super.onLoad();
  }

  void moveAlongPoints() {
    final rand = math.Random();
    final horMove = ghostData?.horMove ?? false;
    final verMove = ghostData?.verMove ?? false;
    final sign = <double>[-1, -1, 0, 1, 1];
    timer = async.Timer.periodic(const Duration(seconds: 2), (timer) {
      Vector2 res = Vector2(0, 0);
      if (horMove) res.x = sign[rand.nextInt(5)];
      if (verMove) res.y = sign[rand.nextInt(5)];
      body.applyLinearImpulse(res * 2000);
    });
  }

  @override
  void onRemove() {
    timer?.cancel();
    super.onRemove();
  }

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();

    final vertices = [
      Vector2(-size.x / 2, -size.y / 2),
      Vector2(size.x / 2, -size.y / 2),
      Vector2(0, size.y / 2),
    ];
    shape.set(vertices);

    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.3
      ..density = 1.0
      ..friction = 0.2;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = position
      ..type = type;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(MassData()..mass = 30);
  }
}
