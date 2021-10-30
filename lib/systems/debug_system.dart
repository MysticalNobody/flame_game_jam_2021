part of systems;

class DebugSystem extends BaseSystem {
  final debugPaint = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke;

  final textPainter = flame.TextPaint(
    config: const flame.TextPaintConfig(
      color: Colors.green,
      fontSize: 10,
    ),
  );

  final statusPainter = flame.TextPaint(
    config: const flame.TextPaintConfig(
      color: Colors.green,
      fontSize: 16,
    ),
  );

  @override
  List<Filter<Component>> get filters => [];

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    statusPainter.render(
      canvas,
      [
        'FPS: ${(world!.game as flame.FPSCounter).fps()}',
        'Entities: ${world!.entities.length}',
      ].join('\n'),
      flame.Vector2.zero(),
    );
  }

  @override
  void renderEntity(Canvas canvas, Entity entity) {
    final size = entity.get<SizeComponent>()!.size;

    canvas.drawRect(flame.Vector2.zero() & size, debugPaint);

    textPainter.render(
      canvas,
      [
        'position: ${entity.get<PositionComponent>()!.position}',
        'size: $size',
        'angle: ${entity.get<AngleComponent>()?.radians ?? 0}',
        'anchor: ${entity.get<AnchorComponent>()?.anchor ?? Anchor.topLeft}',
      ].join('\n'),
      flame.Vector2(size.x + 2, 0),
    );
    textPainter.render(
      canvas,
      entity.name ?? '',
      flame.Vector2(size.x / 2, size.y + 2),
      anchor: Anchor.topCenter,
    );
  }
}
