part of components;

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent(
    this.size,
    sprite,
  ) : super(
          priority: ComponentsPriority.background.index,
          size: size,
          sprite: sprite,
        );

  final Vector2 size;
}
