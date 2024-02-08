import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_router/router/nomo_navigator.dart';
import 'package:nomo_ui_kit/components/app/routebody/nomo_route_body.dart';
import 'package:nomo_ui_kit/icons/nomo_icons.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:nomo_ui_kit/theme/theme_provider.dart';
import 'package:swapping_webon/routes.dart';
import 'package:swapping_webon/theme/theme.dart';
import 'package:swapping_webon/widgets/swap_card.dart';

class SwappingScreen extends ConsumerWidget {
  const SwappingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ThemeProvider.of(context);
    return NomoRouteBody(
      builder: (context, route) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (themeProvider.colorTheme == ColorMode.DARK.theme)
                IconButton(
                  onPressed: () {
                    ThemeProvider.of(context).changeColorTheme(
                      ColorMode.LIGHT.theme,
                    );
                  },
                  icon: const Icon(
                    Icons.light_mode,
                    color: Colors.white,
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    ThemeProvider.of(context).changeColorTheme(
                      ColorMode.DARK.theme,
                    );
                  },
                  icon: const Icon(
                    Icons.dark_mode,
                  ),
                ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  NomoNavigator.of(context).push(HistoryScreenRoute());
                },
                icon: Icon(NomoIcons.clockRotateLeft,
                    color: context.theme.colors.foreground1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SwapCard(),
        ],
      ),
    );
  }
}
