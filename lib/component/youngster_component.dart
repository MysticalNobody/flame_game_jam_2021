part of components;

class YoungsterComponent extends SpriteBodyComponent with Draggable {
  YoungsterComponent({
    required this.title,
    required this.game,
    required this.position,
    required Vector2 size,
  })  : sprite = game.getSprite(title),
        super(game.getSprite(title), size);

  final Vector2 position;
  final SpritesTitles title;
  final AppGame game;
  final Sprite sprite;

  ThrowingTrajectoryComponent? throwingTrajectory;
  bool dragging = false;
  Vector2? dragStart;
  Vector2? dragDiff;

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    log(info.eventPosition.game.toString());
    dragging = true;
    dragStart = info.eventPosition.game;
    return super.onDragStart(pointerId, info);
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo event) {
    if (dragging == true) {
      dragDiff = event.eventPosition.game - dragStart!;
    }
    return super.onDragUpdate(pointerId, event);
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo event) {
    // body.applyForce(event.velocity * 100);
    // if ((dragDiff?.length ?? 0) > 20) {
    game.add(
      FlyingCandyComponent(
        game: game,
        position: body.position + Vector2(100, 100),
        velocity: Vector2(300, 300)
          ..multiply(
            (-dragDiff!
              ..divide(Vector2(300, 300))),
          ), //Vector2(dragDiff!.x, -dragDiff!.y),
      ),
    );
    // }
    dragging = false;
    log('velocity ${event.velocity} dragDiff $dragDiff');
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
      ..position = position
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(MassData());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    throwingTrajectory = ThrowingTrajectoryComponent(
      game: game,
      position: position,
    );
    await add(throwingTrajectory!);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (throwingTrajectory != null && dragging) {
      throwingTrajectory!
          .showDrag(Vector2(100 + body.position.x, body.position.y), dragDiff!);
    } else {
      throwingTrajectory!.hideDrag();
    }
  }
}

class FlyingCandyComponent extends BodyComponent with HasPaint {
  FlyingCandyComponent({
    required this.game,
    required this.position,
    required this.velocity,
  }) : super();
  final AppGame game;
  Vector2 position = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  @override
  Body createBody() {
    final CircleShape shape = CircleShape()..radius = 10;

    final fixtureDef = FixtureDef(shape)
      ..userData = this // To be able to determine object in collision
      ..restitution = 0.3
      ..density = 1.0
      ..friction = 0.2;

    final bodyDef = BodyDef()
      ..position = position
      ..userData = this
      ..linearVelocity = velocity
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(MassData()..mass = 10)
      ..inertia = 100
      ..applyForce(velocity);
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
      double x = -position.x -
          velocity.x * time -
          (game.world.gravity.x / 2) * time * time;
      double y = -position.y +
          (velocity.y * time - (game.world.gravity.y / 2) * time * time);
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
