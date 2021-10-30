part of components;

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent(
    size,
    sprite,
  ) : super(
          priority: ComponentsPriority.background.index,
          size: size,
          sprite: sprite,
        );
}
