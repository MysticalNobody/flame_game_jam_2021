part of entities;

class CandyBagEntityFactory {
  CandyBagEntityFactory._();
  static final size = flame.Vector2.zero();
  static const angle = 0.0;
  static void create({required AppGame game, required int index}) {
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
