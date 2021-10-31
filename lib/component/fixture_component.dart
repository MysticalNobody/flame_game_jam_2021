part of components;

/// obstacle to bounce

/// obstacle to win

/// obstacle to lose

enum ObstacleType {
  bounce,
  win,
  lose,
}

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
    if (b.candyKeeper.candies.length > game.initalCandyCount) {
      onWin();
    }
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
    required SpritesTitles title,
    required Vector2 position,
    required Vector2 size,
    BodyType type = BodyType.dynamic,
  }) : super(
          game: game,
          position: position,
          size: size,
          title: title,
          type: type,
        );
  factory WinObstacleComponent.create({
    required AppGame game,
    required Vector2 position,
  }) =>
      WinObstacleComponent(
        game: game,
        title: SpritesTitles.candyBag,
        position: position,
        type: BodyType.static,
        size: Vector2(100, 100),
      );

  late final candyKeeper = CandyKeeper(position: position, game: game);
}

/// Like a wall
class BounceObstacleComponent extends BaseObstacleComponent {
  BounceObstacleComponent({
    required AppGame game,
    required SpritesTitles title,
    required Vector2 position,
    required Vector2 size,
    BodyType type = BodyType.dynamic,
  }) : super(
          game: game,
          position: position,
          size: size,
          title: title,
          type: type,
        );
  factory BounceObstacleComponent.create({
    required AppGame game,
    required Vector2 position,
  }) =>
      BounceObstacleComponent(
        game: game,
        title: SpritesTitles.candyBag,
        position: position,
        type: BodyType.static,
        size: Vector2(100, 100),
      );
}

/// Like a ghost
class KillingObstacleComponent extends BaseObstacleComponent {
  KillingObstacleComponent({
    required AppGame game,
    required SpritesTitles title,
    required Vector2 position,
    required Vector2 size,
    BodyType type = BodyType.dynamic,
  }) : super(
          game: game,
          position: position,
          size: size,
          title: title,
          type: type,
        );
  KillingObstacleComponent.animated({
    required AppGame game,
    required SpritesTitles title,
    required List<Sprite> sprites,
    required double stepTime,
    required Vector2 position,
    required Vector2 size,
    BodyType type = BodyType.dynamic,
  }) : super.animated(
          game: game,
          position: position,
          size: size,
          title: title,
          type: type,
          sprites: sprites,
          stepTime: stepTime,
        );
  factory KillingObstacleComponent.create({
    required AppGame game,
    required Vector2 position,
  }) {
    final titles = [
      SpritesTitles.ghost1,
      SpritesTitles.ghost2,
      SpritesTitles.ghost3,
      SpritesTitles.ghost4,
      SpritesTitles.ghost5,
    ];
    final title = titles[math.Random().nextInt(5)];
    return KillingObstacleComponent.animated(
      game: game,
      title: title,
      position: position,
      size: Vector2(100, 120),
      stepTime: 1,
      sprites: titles.map((_) => game.getSprite(_)).toList(),
    );
  }
}

/// Like a ghost
class BaseObstacleComponent extends AnimatedSpriteBodyComponent {
  BaseObstacleComponent({
    required this.title,
    required this.game,
    required this.position,
    required Vector2 size,
    this.type = BodyType.dynamic,
  })  : sprite = game.getSprite(title),
        super(
          SpriteAnimation.spriteList([game.getSprite(title)], stepTime: 1),
          size,
        );
  BaseObstacleComponent.animated({
    required this.title,
    required List<Sprite> sprites,
    required double stepTime,
    required this.game,
    required this.position,
    required Vector2 size,
    this.type = BodyType.dynamic,
  })  : sprite = game.getSprite(title),
        super(
          SpriteAnimation.spriteList(sprites, stepTime: stepTime),
          size,
        );

  final Vector2 position;
  final SpritesTitles title;
  final AppGame game;
  final Sprite sprite;
  final BodyType type;

  async.Timer? timer;

  @override
  Future<void> onLoad() {
    moveAlongPoints();
    return super.onLoad();
  }

  void moveAlongPoints() {
    timer = async.Timer.periodic(const Duration(seconds: 2), (timer) {
      final rand = math.Random();
      final sign = [-1, -1, 0, 1, 1][rand.nextInt(5)];
      final dir = [-1, 0, 0, 0, 1][rand.nextInt(5)];
      body.applyLinearImpulse(Vector2(dir * sign * 2000, dir * sign * 2000));
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
