import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:swapping_webon/widgets/token.dart';

class BalanceDisplay extends ConsumerWidget {
  final Token token;
  const BalanceDisplay(this.token, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NomoText(token.symbol);
  }
}
