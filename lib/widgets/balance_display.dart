import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:swapping_webon/utils.dart/amount.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class BalanceDisplay extends ConsumerWidget {
  final Token token;
  const BalanceDisplay(this.token, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = Amount.fromString(
        value: token.balance ?? "0", decimals: token.decimals);

    return NomoText(amount.displayValue.toString());
  }
}
