import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/app/routebody/nomo_route_body.dart';
import 'package:swapping_webon/widgets/swap_card.dart';

class SwappingScreen extends StatelessWidget {
  const SwappingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NomoRouteBody(
      builder: (context, route) => const Center(
        child: SwapCard(),
      ),
    );
  }
}
