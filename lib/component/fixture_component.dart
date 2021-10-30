part of components;

class FixtureComponent extends SpriteBodyComponent {
  FixtureComponent({
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

  factory FixtureComponent.createWall({
    required AppGame game,
    required Vector2 position,
  }) =>
      FixtureComponent(
        game: game,
        title: SpritesTitles.wall,
        position: position,
        type: BodyType.static,
        size: Vector2(100, 100),
      );

  factory FixtureComponent.createCandyBag({
    required AppGame game,
    required Vector2 position,
  }) =>
      FixtureComponent(
        game: game,
        size: Vector2(100, 100),
        title: SpritesTitles.candyBag,
        position: position,
      );

  factory FixtureComponent.createGhost({
    required AppGame game,
    required Vector2 position,
  }) =>
      FixtureComponent(
        game: game,
        title: SpritesTitles.ghost,
        position: position,
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
      ..position = position
      ..angle = (position.x + position.y) / 2 * 3.14
      ..type = type;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
