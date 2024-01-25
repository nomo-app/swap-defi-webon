// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// RouteGenerator
// **************************************************************************

class AppRouter extends NomoAppRouter {
  AppRouter()
      : super(
          {
            SwappingScreenRoute.path: ([a]) => SwappingScreenRoute(),
            HistoryScreenRoute.path: ([a]) => HistoryScreenRoute(),
          },
          _routes.expanded.toList(),
        );
}

class SwappingScreenArguments {
  const SwappingScreenArguments();
}

class SwappingScreenRoute extends AppRoute implements SwappingScreenArguments {
  SwappingScreenRoute()
      : super(
          name: '/',
          page: const SwappingScreen(),
        );
  static String path = '/';
}

class HistoryScreenArguments {
  const HistoryScreenArguments();
}

class HistoryScreenRoute extends AppRoute implements HistoryScreenArguments {
  HistoryScreenRoute()
      : super(
          name: '/history',
          page: const HistoryScreen(),
        );
  static String path = '/history';
}
