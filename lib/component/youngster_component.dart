part of components;

class YoungsterAnimationComponent extends SpriteAnimationComponent {
  YoungsterAnimationComponent(
    SpriteAnimation animation,
    Vector2 spriteSize,
  ) : super(size: spriteSize, animation: animation, position: -spriteSize / 2);
}

class YoungsterComponent extends BodyComponent with Draggable, EquatableMixin {
  YoungsterComponent({
    required this.title,
    required this.game,
    required this.size,
    required this.initialPosition,
  }) : id = uuid.v4();

  factory YoungsterComponent.create({
    required AppGame game,
    required Vector2 position,
  }) {
    final title = [
      SpritesTitles.youngBoy,
      SpritesTitles.youngGirl,
      SpritesTitles.princess,
    ][math.Random().nextInt(3)];

    return YoungsterComponent(
      game: game,
      size: Vector2(130, 220),
      initialPosition: position,
      title: title,
    );
  }
  @override
  final debugMode = false;

  final Vector2 initialPosition;
  final Vector2 size;

  final _candies = <SpritesTitles, int>{};
  final _candiesBodies = <SpritesTitles, FlyingCandyComponent>{};
  void addCandy(SpritesTitles title) {
    final isExisted = _candies.containsKey(title);
    _candies[title] = (_candies[title] ?? 0) + 1;
    final positionX = body.position.x + FlyingCandyComponent.shapeSize;
    final position = Vector2(positionX, body.position.y);
    if (!isExisted) {
      final candy = FlyingCandyComponent.create(
        game: game,
        velocity: Vector2.zero(),
        position: position,
        title: title,
      )..inPlayerBag = true;
      game.add(candy);
      _candiesBodies[title] = candy;
    }
  }

  void removeCandy(SpritesTitles title) {
    final isExists = _candies.containsKey(title);
    if (isExists) {
      final count = _candies[title] ?? 0;
      if (count > 1) {
        _candies[title] = count - 1;
      } else {
        _candies.remove(title);
        final candy = _candiesBodies[title];
        if (candy != null) game.remove(candy);
      }
    }
  }

  final String id;
  final SpritesTitles title;
  final AppGame game;

  ThrowingTrajectoryComponent? throwingTrajectory;
  bool dragging = false;
  Vector2? dragStart;
  Vector2? dragDiff;
  bool get dragEnabled => game.player.id == id;
  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    if (dragEnabled) {
      log(info.eventPosition.game.toString());
      dragging = true;
      dragStart = info.eventPosition.game;
    }

    return super.onDragStart(pointerId, info);
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo event) {
    if (dragging && dragEnabled) {
      dragDiff = event.eventPosition.game - dragStart!;
    }
    return super.onDragUpdate(pointerId, event);
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo event) {
    // body.applyForce(event.velocity * 100);
    // if ((dragDiff?.length ?? 0) > 20) {
    if (dragEnabled) {
      SpritesTitles? title;
      if (_candies.isNotEmpty) {
        title = _candies.keys.first;
        removeCandy(title);
      }
      game.add(
        FlyingCandyComponent.create(
          game: game,
          velocity: -dragDiff! * 3, //Vector2(dragDiff!.x, -dragDiff!.y),
          position: body.position + Vector2(0, 130),
          title: title,
        ),
      );
      // }
      dragging = false;
      log('velocity ${event.velocity} dragDiff $dragDiff ');
    }
    return super.onDragEnd(pointerId, event);
  }

  @override
  bool onDragCancel(int pointerId) {
    dragging = false;
    return super.onDragCancel(pointerId);
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
      ..position = initialPosition
      ..type = BodyType.static;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(MassData());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    throwingTrajectory = ThrowingTrajectoryComponent(
      game: game,
      position: body.position,
    );
    await add(throwingTrajectory!);
    final sprites = <Sprite>[];
    for (int i = 1; i <= 6; i++) {
      final spritePath = '${describeEnum(title).snakeCase}_idle/$i.png';
      sprites.add(await game.loadSprite(spritePath));
    }
    await add(
      YoungsterAnimationComponent(
        SpriteAnimation.spriteList(sprites, stepTime: 0.1),
        size,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (throwingTrajectory != null && dragging) {
      throwingTrajectory!.showDrag(
          Vector2(body.position.x, 130 + body.position.y), dragDiff! * 3);
    } else {
      throwingTrajectory!.hideDrag();
    }
  }

  @override
  List<Object?> get props => [id];
}

class FlyingCandyComponent extends SpriteBodyComponent with HasPaint {
  FlyingCandyComponent({
    required this.game,
    required this.position,
    required this.velocity,
    required this.title,
    required Vector2 size,
  })  : id = uuid.v4(),
        super(
          game.getSprite(title),
          size,
        );
  factory FlyingCandyComponent.create({
    required AppGame game,
    required Vector2 velocity,
    required Vector2 position,
    SpritesTitles? title,
  }) {
    final titles = [
      SpritesTitles.candy1,
      SpritesTitles.candy2,
      SpritesTitles.candy3,
      SpritesTitles.candy4,
      SpritesTitles.candy5,
      SpritesTitles.candy6,
    ];
    final effectiveTitle = title ?? titles[math.Random().nextInt(5)];
    return FlyingCandyComponent(
      game: game,
      title: effectiveTitle,
      size: Vector2(shapeSize, shapeSize),
      position: position,
      velocity: velocity,
    );
  }
  final SpritesTitles title;
  final AppGame game;
  bool inPlayerBag = false;
  final Id id;
  Vector2 position = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  static const shapeSize = 20.0;
  @override
  Body createBody() {
    final CircleShape shape = CircleShape()..radius = shapeSize;

    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.1
      ..density = 1.0
      ..friction = 0.5;

    final bodyDef = BodyDef()
      ..position = position
      ..userData = this
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (velocity.isZero()) return;
    velocity = velocity + game.world.gravity * dt * 3;
    body.setTransform(body.position + velocity * dt * 1.75, 0);
  }
}

class ThrowingTrajectoryComponent extends PositionComponent with HasPaint {
  ThrowingTrajectoryComponent({
    required this.game,
    Vector2? position,
  }) : super(
          position: position,
          priority: 20,
        );
  final AppGame game;
  bool show = false;
  Vector2 velocity = Vector2.zero();

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!show) return;
    for (int time = 0; time < 10; time++) {
      double x =
          -position.x - velocity.x * time - game.world.gravity.x * time * time;
      double y = -position.y +
          (velocity.y * time - game.world.gravity.y * time * time) -
          130;
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  void hideDrag() {
    show = false;
  }

  void showDrag(Vector2 position, Vector2 dragDiff) {
    this.position = position;
    velocity = dragDiff;
    show = true;
  }
}
