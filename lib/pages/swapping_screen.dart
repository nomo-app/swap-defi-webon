import 'package:flutter/material.dart';
import 'package:nomo_router/router/nomo_navigator.dart';
import 'package:nomo_ui_kit/components/app/routebody/nomo_route_body.dart';
import 'package:nomo_ui_kit/components/buttons/secondary/nomo_secondary_button.dart';
import 'package:nomo_ui_kit/icons/nomo_icons.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/routes.dart';
import 'package:swapping_webon/widgets/swap_card.dart';

class SwappingScreen extends StatelessWidget {
  const SwappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NomoRouteBody(
      builder: (context, route) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SecondaryNomoButton(
              onPressed: () {
                NomoNavigator.of(context).push(HistoryScreenRoute());
              },
              shape: BoxShape.circle,
              padding: const EdgeInsets.all(8),
              iconSize: 22,
              textStyle: context.theme.typography.b2.copyWith(
                fontWeight: FontWeight.bold,
              ),
              // ignore: deprecated_member_use
              icon: NomoIcons.history,
            ),
          ),
          const SizedBox(height: 16),
          const SwapCard(),
        ],
      ),
    );
  }
}
