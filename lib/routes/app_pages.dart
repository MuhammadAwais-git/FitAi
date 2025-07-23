
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:web_app/home_page.dart';

import '../SplashScreen.dart';
import '../login/LoginPage.dart';
import '../signup/SignUpPage.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpPage(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
    ),

  ];
}
