part of core;

enum CameraFollower { position, component }

class GameCamera {
  GameCamera({required this.game});
  static const worldBounds = Rect.fromLTWH(0, 0, 800, 600);
  static const moveStep = 4;
  final AppGame game;
  Vector2 position = Vector2.zero();
  Vector2 velocity = Vector2.zero();

  CameraFollower follower = CameraFollower.position;
  void followPosition() {
    follower = CameraFollower.position;
    position.setFrom(game.camera.position);
    game.camera.followVector2(position);
  }

  void followComponent(PositionComponent component) {
    game.camera.followComponent(component);
    velocity.setZero();
    follower = CameraFollower.component;
  }

  void moveAlong(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.down:
        velocity.y -= moveStep;
        break;
      case AxisDirection.up:
        velocity.y += moveStep;
        break;
      case AxisDirection.right:
        velocity.x += moveStep;
        break;
      case AxisDirection.left:
        velocity.x -= moveStep;
        break;
    }
  }

  void stopMoveAlong() => velocity.setZero();
}
