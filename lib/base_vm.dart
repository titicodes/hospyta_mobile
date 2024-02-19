import 'package:flutter/foundation.dart';
import 'constants/enum.dart';
import 'locator.dart';
import 'services/navigation_service.dart';
import 'services/storage_service.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _viewState = ViewState.idle;
  NavigationService navigationService = getIt<NavigationService>();
  // UserService userService = getIt<UserService>();
  // AppCache appCache = getIt<AppCache>();
  StorageService storageService = getIt<StorageService>();

  ViewState get viewState => _viewState;

  set viewState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  bool isLoading = false;

  void startLoader() {
    if (!isLoading) {
      isLoading = true;
      viewState = ViewState.busy;
      notifyListeners();
    }
  }

  void stopLoader() {
    if (isLoading) {
      isLoading = false;
      viewState = ViewState.idle;
      notifyListeners();
    }
  }
}
