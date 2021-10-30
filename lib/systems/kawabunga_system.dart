part of systems;

class KawabungaSystem extends BaseSystem with UpdateSystem {
  @override
  List<Filter<Component>> get filters => [
        Has<TextComponent>(),
        Has<TimerComponent>(),
      ];

  @override
  void renderEntity(Canvas canvas, Entity entity) {
    final timer = entity.get<TimerComponent>()!;
    final textComponent = entity.get<TextComponent>()!;
    final textRenderer = flame.TextPaint(
      config: textComponent.config.withColor(
        textComponent.config.color.withOpacity(1 - timer.percentage),
      ),
    );

    textRenderer.render(
      canvas,
      textComponent.text,
      flame.Vector2.zero(),
    );
  }

  @override
  void update(double delta) {
    for (final entity in entities) {
      final textComponent = entity.get<TextComponent>()!;
      final size = entity.get<SizeComponent>()!.size;
      final textRenderer = flame.TextPaint(config: textComponent.config);
      size.setFrom(textRenderer.measureText(textComponent.text));

      final timer = entity.get<TimerComponent>()!;
      timer.timePassed = timer.timePassed + delta;
      if (timer.done) {
        entity.dispose();
      }
    }
  }
}
