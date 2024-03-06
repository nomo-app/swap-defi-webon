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
          _routes.expanded.where((r) => r is! NestedPageRouteInfo).toList(),
          _routes.expanded.whereType<NestedPageRouteInfo>().toList(),
        );
}

class SwappingScreenArguments {
  const SwappingScreenArguments();
}

class SwappingScreenRoute extends AppRoute implements SwappingScreenArguments {
  SwappingScreenRoute()
      : super(
          name: '/',
          page: SwappingScreen(),
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
          page: HistoryScreen(),
        );
  static String path = '/history';
}
