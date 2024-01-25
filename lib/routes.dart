import 'package:flutter/material.dart';
import 'package:nomo_router/router/entities/route.dart';
import 'package:nomo_ui_kit/components/app/scaffold/nomo_scaffold.dart';
import 'package:nomo_ui_kit/nomo_ui_kit_base.dart';
import 'package:route_gen/anotations.dart';
import 'package:swapping_webon/pages/history_screen.dart';
import 'package:swapping_webon/pages/swapping_screen.dart';

part 'routes.g.dart';

Widget wrapper(nav) {
  return Builder(
    builder: (context) {
      return NomoScaffold(
        child: nav,
      );
    },
  );
}

@AppRoutes()
const _routes = [
  MenuNestedPageRouteInfo(
      wrapper: wrapper,
      path: "/",
      page: SwappingScreen,
      title: "Swapping Screen",
      children: [
        MenuPageRouteInfo(
          path: "/history",
          page: HistoryScreen,
          title: "History",
        )
      ]),
];
