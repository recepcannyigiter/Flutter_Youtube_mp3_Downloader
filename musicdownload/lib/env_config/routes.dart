import 'package:get/get.dart';
import 'package:musicdownload/env_config/routelinks.dart';

import '../screens/homescreen/home-binding.dart';
import '../screens/homescreen/homescreen.dart';
import '../screens/searchscreen/searchbinding.dart';
import '../screens/searchscreen/searchscreen.dart';
import '../screens/splashscreen/splashscreen.dart';


class AppRoutes {
  static List<GetPage> ROUTES = [
    GetPage(
      name: Links.SPLASH_SCREEN,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Links.HOME_SCREEN,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Links.SEARCH_SCREEN,
      page: () => const SearchScreen(),
      binding: SearchBinding(),
    ),
  ];
}