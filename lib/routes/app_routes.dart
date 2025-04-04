import 'package:flutter/material.dart';
import 'package:sample/screens/home_page.dart';
import 'package:sample/screens/not_found_page.dart';
import 'package:sample/screens/search_page.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String search = '/search';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    search: (context) => const SearchPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeBuilder = routes[settings.name];

    if (routeBuilder != null) {
      return MaterialPageRoute(builder: routeBuilder);
    }

    return unknownRoute(settings);
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => const NotFoundPage());
  }
}
