import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hospyta_mobile/routes/routes.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hospyta_mobile/services/theme_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'locator.dart';
import 'routes/router.dart';
import 'services/navigation_service.dart';

void main() {
  setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: ScreenUtilInit(
        designSize: const Size(390, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (child, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: getIt<NavigationService>().navigatorKey,
            scaffoldMessengerKey: getIt<NavigationService>().snackBarKey,
            title: 'Your App Title',
            theme: getIt<AppThemeService>().getLightThemeData(),
            darkTheme: getIt<AppThemeService>().getDarkThemeData(),
            themeMode: getIt<AppThemeService>().themeMode == kDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            onGenerateRoute: Routers.generateRoute,
            initialRoute: splashScreenRoute,
            // home: child,
            navigatorObservers: [FlutterSmartDialog.observer],
            // here
            builder: FlutterSmartDialog.init(),
          );
        },
      ),
    );
  }
}
