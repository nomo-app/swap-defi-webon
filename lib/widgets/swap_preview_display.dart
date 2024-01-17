import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/swap_preview.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/widgets/token.dart';

// final gasFeeProvider =
//     FutureProvider.autoDispose.family<double?, TokenEntity>((ref, t) async {
//   // TODO: Check if correct
//   final network = Network.getNetworkFromToken(t)!;
//   final price = ref.watch(priceProvider(network.currency)).price;

//   if (price == null) return null;
//   final gasPrice = (await network.gasPrices).getFee(FeePriority.low);
//   final fee = gasPrice * GasLimits.ethSend.asBigInt;
//   final gasFeeCurr = fee.toInt() / network.currency.subunits * price;
//   return gasFeeCurr;
// });
class SwapPreviewDisplay extends ConsumerWidget {
  const SwapPreviewDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapInfo = ref.watch(swapInfoProvider);
    final rate = ref.watch(swapPreviewProvider).when(
          data: (data) => data.rate,
          error: (error, stackTrace) => null,
          loading: () => null,
        );

    // if (false) return SizedBox.shrink();

    // final ouputUnitValue = 1 / rate;
    // final currency = ref.watch(currencyProvider).symbol;
    // final ouputUnitValueCur =
    //     ouputUnitValue * ref.watch(priceProvider(swapInfo.from)).priceVal;

    return NomoCard(
      borderRadius: BorderRadius.circular(8),
      backgroundColor: context.theme.colors.background2,
      padding: const EdgeInsets.all(12),
      child: const Column(
        children: [
          Row(
            children: [
              NomoText("From: "),
              SizedBox(
                width: 12,
              ),
              NomoText("Amount: "),
            ],
          ),
          Row(
            children: [
              NomoText("To: "),
              SizedBox(
                width: 12,
              ),
              NomoText("Amount: "),
            ],
          ),
        ],
      ),
    );
  }
}
