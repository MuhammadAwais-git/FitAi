part of 'app_pages.dart';

// Define all routes
abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const HOME = _Paths.HOME;

  static const FORGOT = _Paths.FORGOT;


}

// Define route paths
abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const HOME = '/home_page';

  static const FORGOT = '/forgot';

}
