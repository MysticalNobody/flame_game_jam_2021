import 'package:example/core/core.dart';
import 'package:example/presentation/game/game_widget.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppGameView extends StatefulWidget {
  const AppGameView({
    required this.game,
    Key? key,
  }) : super(key: key);
  final Game game;

  @override
  _AppGameViewState createState() => _AppGameViewState();
}

class _AppGameViewState extends State<AppGameView> {
  @override
  Widget build(BuildContext context) {
    return AppGameWidget(game: widget.game);
  }
}

class AppGame extends Forge2DGame {
  AppGame({
    required this.onAssetsLoad,
  });
  final FutureVoidCallback onAssetsLoad;

  @override
  Future<void> onLoad() async {
    // this.remove(c);
    await onAssetsLoad();
    return super.onLoad();
  }
}
