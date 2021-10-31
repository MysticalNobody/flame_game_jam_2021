part of components;

typedef CandiesCountList = List<SpritesTitles>;

class CandyKeeper {
  CandyKeeper({
    required this.game,
    required this.position,
  });
  final CandiesCountList candies = [];
  final candiesBodies = <IdleCandyComponent>[];
  final AppGame game;
  final Vector2 position;
  void addCandy(SpritesTitles title) {
    candies.add(title);
    const countInColumn = 10;
    final columnsCount = candies.length ~/ countInColumn;
    final totalCount = columnsCount * countInColumn;
    int countInCurrentColumn = totalCount - candies.length;
    if (countInCurrentColumn < 0) {
      countInCurrentColumn *= -1;
      countInCurrentColumn--;
    }

    final effectivePosition = Vector2(
      position.x + 90 + 30 * columnsCount,
      -game.bottomLine -
          (FlyingCandyComponent.shapeSize * countInCurrentColumn) +
          60,
    );
    final candy = IdleCandyComponent.create(
      game: game,
      position: effectivePosition,
      title: title,
    );
    game.add(candy);
    candiesBodies.add(candy);
  }

  void removeCandy(SpritesTitles title) {
    if (candies.isEmpty) return;
    final candy = candiesBodies.last;
    if (candy.isMounted) {
      game.remove(candy);
    }
    candiesBodies.removeLast();
    candies.removeLast();
  }
}

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
    required this.initialCandiesCount,
  }) : id = uuid.v4();

  factory YoungsterComponent.create({
    required AppGame game,
    required Vector2 position,
    int? initialCandiesCount,
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
      initialCandiesCount: initialCandiesCount,
    );
  }
  late final candyKeeper = CandyKeeper(position: initialPosition, game: game);
  final Vector2 initialPosition;
  final Vector2 size;

  final String id;
  final SpritesTitles title;
  final AppGame game;
  final int? initialCandiesCount;

  ThrowingTrajectoryComponent? throwingTrajectory;
  bool dragging = false;
  Vector2? dragStart;
  Vector2? dragDiff;
  bool get dragEnabled => true; //game.player.id == id;

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
      bool addCandy = false;
      if (candyKeeper.candies.isNotEmpty) {
        title = candyKeeper.candies.last;
        candyKeeper.removeCandy(title);
        addCandy = true;
      }
      if (debugMode) addCandy = true;
      if (addCandy) {
        game.add(
          FlyingCandyComponent.create(
            game: game,
            velocity: -dragDiff! * 3, //Vector2(dragDiff!.x, -dragDiff!.y),
            position: body.position + Vector2(50, 10),
            title: title,
          ),
        );
        // }
        log('velocity ${event.velocity} dragDiff $dragDiff ');
      }
      dragging = false;
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
    for (var i = 0; i < (initialCandiesCount ?? 0); i++) {
      final candyTitle = FlyingCandyComponent.getRandomCandy();
      candyKeeper.addCandy(candyTitle);
    }

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
        Vector2(50 + body.position.x, 10 + body.position.y),
        dragDiff! * 3,
      );
    } else {
      throwingTrajectory!.hideDrag();
    }
  }

  @override
  List<Object?> get props => [id];
}

class IdleCandyComponent extends SpriteComponent {
  IdleCandyComponent({
    required this.game,
    required Vector2 position,
    required this.title,
    required Vector2 size,
  })  : id = uuid.v4(),
        super(
          size: size,
          position: position,
          priority: ComponentsPriority.candy.index,
          sprite: game.getSprite(title),
        );
  factory IdleCandyComponent.create({
    required AppGame game,
    required Vector2 position,
    required SpritesTitles title,
  }) =>
      IdleCandyComponent(
        game: game,
        title: title,
        size: Vector2(
          FlyingCandyComponent.shapeSize,
          FlyingCandyComponent.shapeSize,
        ),
        position: position,
      );

  static final TextPaint textConfig = TextPaint(
    config: const TextPaintConfig(
      color: Color(0xFFFFFFFF),
    ),
  );
  final SpritesTitles title;
  final AppGame game;
  final Id id;
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
    final effectiveTitle = title ?? getRandomCandy();
    return FlyingCandyComponent(
      game: game,
      title: effectiveTitle,
      size: Vector2(shapeSize, shapeSize),
      position: position,
      velocity: velocity,
    );
  }
  static SpritesTitles getRandomCandy() {
    final titles = [
      SpritesTitles.candy1,
      SpritesTitles.candy2,
      SpritesTitles.candy3,
      SpritesTitles.candy4,
      SpritesTitles.candy5,
      SpritesTitles.candy6,
    ];
    return titles[math.Random().nextInt(5)];
  }

  final SpritesTitles title;
  final AppGame game;
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
    dt *= 2;
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
    for (int time = 0; time < 5; time++) {
      double x = -position.x -
          velocity.x * time -
          game.world.gravity.x * time * time +
          50;
      double y = -position.y +
          (velocity.y * time - game.world.gravity.y * time * time) -
          10;
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
