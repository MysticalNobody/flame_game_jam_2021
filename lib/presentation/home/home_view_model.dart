import 'package:stacked/stacked.dart';

enum Pages { menu, game }

class HomeViewModel extends BaseViewModel {
  Pages page = Pages.menu;

  void changePage(Pages page) {
    this.page = page;
    notifyListeners();
  }

  Future<void> init() async {}
}
