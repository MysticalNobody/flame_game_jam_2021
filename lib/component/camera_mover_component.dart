import 'dart:developer';

import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_view.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class CameraMoverComponent extends PositionComponent with Draggable {
  CameraMoverComponent(this.camera) : super(size: camera.game.size);

  bool dragging = false;
  Vector2? dragStart;
  Vector2? dragDiff;
  final GameCamera camera;

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
      position = event.eventPosition.game;
      log(position.toString());
    }
    return super.onDragUpdate(pointerId, event);
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo event) {
    dragging = false;
    return super.onDragEnd(pointerId, event);
  }

  @override
  bool onDragCancel(int pointerId) {
    dragging = false;
    return super.onDragCancel(pointerId);
  }
}
