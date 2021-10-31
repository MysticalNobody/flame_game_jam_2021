import 'package:stacked/stacked.dart';

enum Pages { menu, hint, game, gameOver, credits }

class HomeViewModel extends BaseViewModel {
  Pages page = Pages.gameOver;

  void changePage(Pages page) {
    this.page = page;
    notifyListeners();
  }

  Future<void> init() async {}
  int seconds = 0;
  void showGameOver(Duration newSeconds) {
    seconds = newSeconds.inSeconds;
    if (seconds < 0) seconds *= -1;
    changePage(Pages.gameOver);
  }
}
