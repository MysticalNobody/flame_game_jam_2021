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
            position: position);
}
