part of components;

class CandyComponent extends SpriteBodyComponent {
  CandyComponent({
    required Sprite sprite,
    required Vector2 spriteSize,
    required this.position,
  }) : super(sprite, spriteSize);
  final Vector2 position;

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
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
