part of components;

abstract class AnimatedSpriteBodyComponent<T extends Forge2DGame>
    extends PositionBodyComponent<T> {
  AnimatedSpriteBodyComponent(
    SpriteAnimation animation,
    Vector2 spriteSize,
  ) : super(
          SpriteAnimationComponent(size: spriteSize, animation: animation),
          spriteSize,
        );
}
