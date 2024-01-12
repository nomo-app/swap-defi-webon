import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/asset_provider.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/widgets/amount.dart';
import 'package:swapping_webon/widgets/token.dart';

class InputActions extends ConsumerWidget {
  final bool isFrom;
  const InputActions({required this.isFrom, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(swapInfoProvider);
    final balance = isFrom ? token.from.balance : token.to.balance;
    final decimals = isFrom ? token.from.decimals : token.to.decimals;
    final amount = Amount.fromString(value: balance ?? "0", decimals: decimals);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: NomoText(
            amount.displayValue.toString(),
            style: context.theme.typography.b1,
            opacity: 0.5,
            maxLines: 2,
            minFontSize: 8,
          ),
        ),
        Row(
          children: [
            InputActionButton(
              onPressed: () {
                selectAmount(0.25, ref, isFrom);
              },
              text: "25%",
            ),
            const SizedBox(width: 8),
            InputActionButton(
              onPressed: () {
                selectAmount(0.5, ref, isFrom);
              },
              text: "50%",
            ),
            const SizedBox(width: 8),
            InputActionButton(
              onPressed: () {
                selectAmount(0.75, ref, isFrom);
              },
              text: "75%",
            ),
            const SizedBox(width: 8),
            InputActionButton(
              onPressed: () {
                selectAmount(1, ref, isFrom);
              },
              text: "max",
            ),
          ],
        )
      ],
    );
  }

  selectAmount(double percentage, WidgetRef ref, bool isFrom) {
    final token =
        ref.read(isFrom ? fromProvider.notifier : toProvider.notifier).state;

    final amount = Amount.fromString(
        value: token?.balance ?? "0", decimals: token?.decimals ?? 0);
    final value = amount.displayValue * percentage;

    if (token != null) {
      var updatedToken = token.copyWith(
        selectedValue: value,
      );
      ref.read(isFrom ? fromProvider.notifier : toProvider.notifier).state =
          updatedToken;
    }
  }
}

class InputActionButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const InputActionButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return NomoButton(
      width: 40,
      borderRadius: BorderRadius.circular(4),
      backgroundColor: context.theme.colors.background2,
      border: Border.all(
        color: context.theme.colors.primary,
        width: 1,
      ),
      child: NomoText(
        minFontSize: 8,
        text,
        style: context.theme.typography.b1,
        color: context.theme.colors.primary,
      ),
      onPressed: () => onPressed(),
    );
  }
}
