import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/nomo_ui_kit_base.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/routes.dart';
import 'package:swapping_webon/theme/theme.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

final appRouter = AppRouter();

void main() {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: NomoApp(
        sizingThemeBuilder: (width) => switch (width) {
          < 480 => sizingSmall,
          < 1080 => sizingMedium,
          _ => sizingLarge,
        },
        theme: NomoThemeData(
          colorTheme: ColorMode.LIGHT.theme,
          sizingTheme: SizingMode.LARGE.theme,
          textTheme: typography,
          constants: constants,
        ),
        supportedLocales: const [Locale('en', 'US')],
        appRouter: appRouter,
      ),
    );
  }
}
