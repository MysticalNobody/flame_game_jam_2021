part of components;

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent({
    required Vector2 size,
    required Sprite sprite,
    required Vector2 position,
  }) : super(
          priority: ComponentsPriority.background.index,
          size: size,
          sprite: sprite,
          position: position,
        );
  factory BackgroundComponent.create({
    required AppGame game,
    required SpritesTitles title,
  }) {
    final sprite = game.getSprite(title);
    final size = sprite.srcSize;
    final diff = size.y / game.worldBounds.height;
    final homeSize = Vector2(size.x / diff, game.worldBounds.height);
    return BackgroundComponent(
      size: homeSize,
      sprite: sprite,
      position: Vector2(0, -(game.worldBounds.height - homeSize.y)),
    );
  }
}
