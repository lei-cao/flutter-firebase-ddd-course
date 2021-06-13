import 'package:auto_route/annotations.dart';
import 'package:flutter_firebase_ddd_course/presentation/sign_in/sign_in_page.dart';
import 'package:flutter_firebase_ddd_course/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
  ],
)
class $RootRouter {}
