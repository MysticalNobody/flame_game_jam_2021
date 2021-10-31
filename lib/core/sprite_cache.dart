part of core;

enum SpritesTitles {
  candyBag,
  ghost1,
  ghost2,
  ghost3,
  ghost4,
  ghost5,
  candy1,
  candy2,
  candy3,
  candy4,
  candy5,
  candy6,
  bg,
  bgHome,
  bgHome1,
  bgHome2,
  bgRoadStart,
  bgRoadMiddle,
  youngBoy,
  youngGirl,
}

class SpritesCache with Loadable {
  SpritesCache({required this.game});
  final AppGame game;
  final Map<SpritesTitles, Sprite> sprites = {};
  @override
  Future<void>? onLoad() async {
    for (final spriteTitle in SpritesTitles.values) {
      final spritePath = '${describeEnum(spriteTitle).snakeCase}.png';
      sprites[spriteTitle] = await game.loadSprite(spritePath);
    }
    await super.onLoad();
  }
}
