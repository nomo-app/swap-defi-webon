import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/utils.dart/numbers.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/utils.dart/amount.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class InputActions extends ConsumerWidget {
  final bool isFrom;
  final ValueNotifier<String> textNotifier;
  const InputActions(
      {required this.textNotifier, required this.isFrom, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapinfo = ref.watch(swapInfoProvider);
    final balance = isFrom ? swapinfo.from.balance : swapinfo.to.balance;
    final decimals = isFrom ? swapinfo.from.decimals : swapinfo.to.decimals;
    final amount = Amount.fromString(value: balance ?? "0", decimals: decimals);

    final token = isFrom ? swapinfo.from : swapinfo.to;

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
                selectAmount(0.25, ref, isFrom, token, textNotifier);
              },
              text: "25%",
            ),
            const SizedBox(width: 8),
            InputActionButton(
              onPressed: () {
                selectAmount(0.5, ref, isFrom, token, textNotifier);
              },
              text: "50%",
            ),
            const SizedBox(width: 8),
            InputActionButton(
              onPressed: () {
                selectAmount(0.75, ref, isFrom, token, textNotifier);
              },
              text: "75%",
            ),
            const SizedBox(width: 8),
            InputActionButton(
              onPressed: () {
                selectAmount(1, ref, isFrom, token, textNotifier);
              },
              text: "max",
            ),
          ],
        )
      ],
    );
  }

  selectAmount(double percentage, WidgetRef ref, bool isFrom, Token token,
      ValueNotifier<String> textNotifier) {
    final amount =
        Amount.fromString(value: token.balance!, decimals: token.decimals);
    final valueToSet =
        BigNumbers(token.decimals).multiplyBI(amount.value, percentage);
    final amountToSet = Amount(value: valueToSet, decimals: token.decimals);
    if (isFrom) {
      textNotifier.value = amountToSet.getDisplayString(5);
    } else {
      textNotifier.value = amountToSet.getDisplayString(5);
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
