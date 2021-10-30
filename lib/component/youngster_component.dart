part of components;

class YoungsterComponent extends SpriteBodyComponent with Draggable {
  YoungsterComponent({
    required this.title,
    required this.game,
    required this.position,
    required Vector2 size,
  })  : sprite = game.getSprite(title),
        super(
          game.getSprite(title),
          size * game.aspectRatio,
        );

  final Vector2 position;
  final SpritesTitles title;
  final AppGame game;
  final Sprite sprite;
  MouseJoint? mouseJoint;
  Vector2 getSpriteSize() => sprite.srcSize * game.aspectRatio;

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    log(info.eventPosition.game.toString());
    return super.onDragStart(pointerId, info);
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo event) {
    return super.onDragUpdate(pointerId, event);
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo event) {
    body.applyForce(event.velocity * 100);
    log(event.velocity.toString());
    return super.onDragEnd(pointerId, event);
  }

  @override
  bool onDragCancel(int pointerId) {
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
      ..angle = (position.x + position.y) / 2 * 3.14
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setMassData(MassData());
  }
}
