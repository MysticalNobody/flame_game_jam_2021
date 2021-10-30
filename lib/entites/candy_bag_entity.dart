part of entities;

class CandyBagEntity {
  CandyBagEntity.of(this.game);
  final AppGame game;
  final size = flame.Vector2.zero();
  final angle = 0.0;
  void create({required int index}) {
    //  game.createEntity(
    //   name: '${EntityTitles.candy} $index',
    //   position: size / 2,
    //   size: flame.Vector2.all(64),
    //   angle: 0,
    // )
    //   .add<SpriteComponent, SpriteInit>(
    //     SpriteInit(await loadSprite('pizza.png')),
    //   );
    // ..add<VelocityComponent, Vector2>(
    //   Vector2(
    //     random.nextDouble() * 100 * (random.nextBool() ? 1 : -1),
    //     random.nextDouble() * 100 * (random.nextBool() ? 1 : -1),
    //   ),
    // );
  }
}
