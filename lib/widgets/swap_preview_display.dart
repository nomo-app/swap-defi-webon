import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:nomo_ui_kit/utils/layout_extensions.dart';
import 'package:swapping_webon/utils.dart/js_communication.dart';
import 'package:swapping_webon/utils.dart/numbers.dart';
import 'package:swapping_webon/provider/swap_preview.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/utils.dart/amount.dart';

class SwapPreviewDisplay extends ConsumerWidget {
  const SwapPreviewDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapInfo = ref.watch(swapInfoProvider);
    final rate = ref.watch(swapPreviewProvider);

    final priceOfTo = ref.watch(priceProvider(swapInfo.to.symbol));

    if (rate.hasValue && priceOfTo.hasValue) {
      BigInt toInToken = BigNumbers(swapInfo.to.decimals)
              .convertInputDoubleToBI(rate.value?.rate) ??
          BigInt.zero;

      Amount amountInToken =
          Amount(value: toInToken, decimals: swapInfo.to.decimals);

      BigInt amountTo = BigNumbers(swapInfo.to.decimals)
              .convertInputDoubleToBI(rate.value?.amount) ??
          BigInt.zero;

      Amount amount = Amount(value: amountTo, decimals: swapInfo.to.decimals);

      double pricePerTokenTo = priceOfTo.value!["price"];
      double totalPrice = pricePerTokenTo * amount.displayValue;

      return NomoCard(
        borderRadius: BorderRadius.circular(8),
        backgroundColor: context.theme.colors.background2,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: context.theme.colors.primary,
            ),
            NomoText(
              "1 ${swapInfo.from.symbol} = ${amountInToken.getDisplayString(5)} ${swapInfo.to.symbol}",
              style: context.theme.typography.b2,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 8,
            ),
            NomoText(
              "${amount.getDisplayString(5)} ${swapInfo.to.symbol} = ${totalPrice.toStringAsFixed(2)} ${priceOfTo.value!["currencyDisplayName"]}",
              style: context.theme.typography.b2,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
