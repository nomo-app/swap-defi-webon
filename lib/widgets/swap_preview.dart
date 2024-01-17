import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/widgets/token.dart';

class SwapPreview extends StatelessWidget {
  final Token from;
  final Token to;
  final String fromAmount;
  final String toAmount;

  const SwapPreview(
      {super.key,
      required this.from,
      required this.to,
      required this.fromAmount,
      required this.toAmount});

  @override
  Widget build(BuildContext context) {
    return NomoCard(
      borderRadius: BorderRadius.circular(8),
      backgroundColor: context.theme.colors.background2,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              NomoText("From: ${from.symbol}"),
              const SizedBox(
                width: 12,
              ),
              NomoText("Amount: $fromAmount"),
            ],
          ),
          Row(
            children: [
              NomoText("To: ${to.symbol}"),
              const SizedBox(
                width: 12,
              ),
              NomoText("Amount: $toAmount"),
            ],
          ),
        ],
      ),
    );
  }
}
