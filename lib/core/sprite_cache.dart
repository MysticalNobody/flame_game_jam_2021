part of core;

enum SpritesTitles {
  candyBag,
  ghost,
  bg,
  wall,
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
