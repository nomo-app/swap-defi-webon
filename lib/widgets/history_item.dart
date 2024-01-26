import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/secondary/nomo_secondary_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/icons/nomo_icons.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/model/history_model.dart';
import 'package:swapping_webon/provider/model/swapinfo.dart';
import 'package:swapping_webon/provider/model/tx_history_entity.dart';
import 'package:swapping_webon/utils.dart/js_communication.dart';
import 'package:swapping_webon/widgets/currency_item.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class HistoryItem extends ConsumerWidget {
  final HistoryModel item;

  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var status = item.transaction.confirmationState;
    final assetsFromApp = ref.watch(visibleAssetsProvider);

    Token to = nullToken;
    Token from = nullToken;
    if (assetsFromApp.hasValue) {
      to = assetsFromApp.value!
          .firstWhere((element) => element.symbol == item.toSymbol);
      from = assetsFromApp.value!
          .firstWhere((element) => element.symbol == item.fromSymbol);
    }

    return InkWell(
      onTap: () {
        //AppNavigator.toSwapOrderInfo(item);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrencyItem(
              currency: from,
              status: status,
            ),
            Container(
              margin: const EdgeInsets.only(top: 17, left: 8, right: 8),
              alignment: Alignment.topCenter,
              child: Icon(
                NomoIcons.arrowRight,
                color: context.theme.colors.foreground2,
                textDirection: TextDirection.rtl,
                size: 20,
              ),
            ),
            CurrencyItem(
              currency: to,
              status: status,
            ),
            if (status == SwapTxConfirmationState.review)
              Container(
                margin: const EdgeInsets.only(top: 12, left: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.colors.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.reviews,
                  color: context.theme.colors.onPrimary,
                  size: 20,
                ),
              )
            else if (status != SwapTxConfirmationState.settled)
              Container(
                margin: const EdgeInsets.only(top: 12, left: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.colors.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  status == SwapTxConfirmationState.expired
                      ? Icons.block
                      : Icons.schedule,
                  color: context.theme.colors.onPrimary,
                  size: 20,
                ),
              )
            else if (status == SwapTxConfirmationState.settled)
              Container(
                margin: const EdgeInsets.only(top: 8, left: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.theme.colors.surface,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.check,
                  color: Colors.green[900],
                  size: 28,
                ),
              ),
            const Spacer(),
            Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                SecondaryNomoButton(
                  iconSize: 18,
                  icon: NomoIcons.info,
                  shape: BoxShape.circle,
                  padding: const EdgeInsets.all(8),
                  onPressed: () async {
                    final url = "https://sideshift.ai/orders/${item.id}";
                    await WebonKitDart.launchUrl(
                      url: url,
                      launchMode: WebonKitDartUrlLaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              width: 22,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                NomoText(
                  item.amount?.toStringAsFixed(4) ?? "n.A ${from.symbol}",
                  style: context.theme.typography.h2,
                  fontSize: 16,
                ),
                const SizedBox(
                  height: 2,
                ),
                NomoText(
                  item.transaction.formattedDate,
                  style: context.theme.typography.b3.copyWith(
                    color: context.typography.b1.color,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
