import 'package:get_it/get_it.dart';
import 'package:hospyta_mobile/services/theme_service.dart';

import 'services/navigation_service.dart';
import 'services/storage_service.dart';

GetIt getIt = GetIt.I;

const String baseUrl = 'https://daytrade.toosabi.ng';

void setupLocator() {
  //View Model
  // getIt.registerFactory<SignUpViewModel>(() => SignUpViewModel());
  // getIt.registerFactory<LoginViewModel>(() => LoginViewModel());

  // // Services
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());

  // getIt.registerLazySingleton<AuthenticationApiService>(
  //     () => AuthenticationApiService());

  // getIt.registerLazySingleton(() => AppCache());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<AppThemeService>(() => AppThemeService());
  //getIt.registerLazySingleton<UserService>(() => UserService());
}
