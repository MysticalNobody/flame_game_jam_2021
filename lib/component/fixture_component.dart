part of components;

/// obstacle to bounce

/// obstacle to win

/// obstacle to lose

enum ObstacleType {
  bounce,
  win,
  lose,
}

class WinContactCallback
    extends ContactCallback<CandyBagComponent, WinObstacleComponent> {
  WinContactCallback({required this.game, required this.onWin});
  final widgets.VoidCallback onWin;
  final AppGame game;
  @override
  void begin(CandyBagComponent a, WinObstacleComponent b, Contact contact) {
    log(b.body.toString());
    onWin();
  }

  @override
  void end(CandyBagComponent a, WinObstacleComponent b, Contact contact) {}
}

class KillingContactCallback
    extends ContactCallback<CandyBagComponent, KillingObstacleComponent> {
  KillingContactCallback({required this.game, required this.onKill});
  final widgets.VoidCallback onKill;
  final AppGame game;
  @override
  void begin(CandyBagComponent a, KillingObstacleComponent b, Contact contact) {
    log(b.body.toString());

    game.remove(a);
    onKill();
  }

  @override
  void end(CandyBagComponent a, KillingObstacleComponent b, Contact contact) {}
}

class BounceContactCallback
    extends ContactCallback<CandyBagComponent, BounceContactCallback> {
  BounceContactCallback({required this.game, required this.onBounce});
  final widgets.VoidCallback onBounce;
  final AppGame game;
  @override
  void begin(CandyBagComponent a, BounceContactCallback b, Contact contact) {
    log(b.toString());
  }

  @override
  void end(CandyBagComponent a, BounceContactCallback b, Contact contact) {}
}

/// Like a door or another player
class CandyBagComponent extends SpriteBodyComponent {
  CandyBagComponent({
    required this.title,
    required this.game,
    required this.position,
    required Vector2 size,
    this.type = BodyType.dynamic,
  })  : sprite = game.getSprite(title),
        super(
          game.getSprite(title),
          size * game.aspectRatio,
        );

  factory CandyBagComponent.create({
    required AppGame game,
    required Vector2 position,
  }) =>
      CandyBagComponent(
        game: game,
        title: SpritesTitles.candyBag,
        position: position,
        // type: BodyType.dynamic,
        size: Vector2(100, 100),
      );

  final Vector2 position;
  final SpritesTitles title;
  final AppGame game;
  final Sprite sprite;
  final BodyType type;

  Vector2 getSpriteSize() => sprite.srcSize * game.aspectRatio;

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
      ..angle = (position.x + position.y) / 2 * 3.14
      ..type = type;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
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
        title: SpritesTitles.wall,
        position: position,
        size: Vector2(100, 100),
      );
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
        title: SpritesTitles.wall,
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
  factory KillingObstacleComponent.create({
    required AppGame game,
    required Vector2 position,
  }) =>
      KillingObstacleComponent(
        game: game,
        title: SpritesTitles.ghost,
        position: position,
        size: Vector2(100, 80),
      );
}

/// Like a ghost
class BaseObstacleComponent extends SpriteBodyComponent {
  BaseObstacleComponent({
    required this.title,
    required this.game,
    required this.position,
    required Vector2 size,
    this.type = BodyType.dynamic,
  })  : sprite = game.getSprite(title),
        super(
          game.getSprite(title),
          size * game.aspectRatio,
        );

  final Vector2 position;
  final SpritesTitles title;
  final AppGame game;
  final Sprite sprite;
  final BodyType type;

  async.Timer? timer;
  widgets.AxisDirection impulseDirection = widgets.AxisDirection.up;
  Vector2 getSpriteSize() => sprite.srcSize * game.aspectRatio;
  void moveAlongPoints() {
    timer = async.Timer.periodic(const Duration(seconds: 5), (timer) {
      final sign = impulseDirection == widgets.AxisDirection.up ? -1 : 1000;
      body.applyLinearImpulse(Vector2(0, sign * 2000));
      if (impulseDirection == widgets.AxisDirection.up) {
        impulseDirection = widgets.AxisDirection.down;
      } else {
        impulseDirection = widgets.AxisDirection.up;
      }
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
      ..setMassData(MassData()..mass = 40);
  }
}
