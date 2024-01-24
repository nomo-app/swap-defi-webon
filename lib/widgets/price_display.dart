import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class PriceDisplay extends ConsumerWidget {
  final Token token;
  const PriceDisplay(this.token, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NomoText(token.name!);
  }
}
