part of systems;

class CandyBagSystem extends BaseSystem with GameRef<AppGame>, UpdateSystem {
  Future<void> createBagEntity() async {
    // CandyBagEntity.create(game);
  }

  @override
  void execute(double delta) {
    // TODO: implement execute
  }

  @override
  void init() {
    // TODO: implement init
  }

  @override
  // TODO: implement filters
  List<Filter<Component>> get filters => throw UnimplementedError();

  @override
  void renderEntity(Canvas canvas, Entity entity) {
    // TODO: implement renderEntity
  }

  @override
  void update(double delta) {
    // TODO: implement update
  }
}
