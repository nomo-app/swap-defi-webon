import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/buttons/text/nomo_text_button.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/loading/shimmer/loading_shimmer.dart';
import 'package:nomo_ui_kit/components/loading/shimmer/shimmer.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/numbers.dart';
import 'package:swapping_webon/provider/swap_preview.dart';
import 'package:swapping_webon/provider/swap_provider.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/provider/swapping_sevice.dart';
import 'package:swapping_webon/widgets/amount.dart';
import 'package:swapping_webon/widgets/error_message.dart';
import 'package:swapping_webon/widgets/input_actions.dart';
import 'package:swapping_webon/widgets/swap_asset_input.dart';
import 'package:swapping_webon/provider/swapinfo.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:swapping_webon/widgets/swap_preview_display.dart';

const textPrecision = 5;

class SwapCard extends StatefulHookConsumerWidget {
  const SwapCard({super.key});

  @override
  ConsumerState<SwapCard> createState() => _SwapCardState();
}

class _SwapCardState extends ConsumerState<SwapCard> {
  final fromTextNotifer = ValueNotifier('');
  final toTextNotifer = ValueNotifier('');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final swapInfo = ref.watch(swapInfoProvider);

    final swapPreview = ref.watch(swapPreviewProvider);

    useEffect(
      () {
        Future.microtask(
          () {
            fromTextNotifer.value = swapInfo.fromIsNullToken
                ? ""
                : swapInfo.fromAmount.getDisplayString(textPrecision);

            toTextNotifer.value = swapInfo.toIsNullToken
                ? ""
                : swapInfo.toAmount.getDisplayString(textPrecision);
          },
        );

        return null;
      },
      [swapInfo.to, swapInfo.from],
    );

    String? errorMessage;

    final balanceValidFrom = ref.watch(balanceValidProvider);

    final fromAmountValid =
        fromTextNotifer.value != "" ? ref.watch(amountValidFromProvider) : true;

    bool showErrorMessage = false;

    if (balanceValidFrom || !fromAmountValid) {
      errorMessage = "Insufficient Balance!";
      showErrorMessage = true;
    }

    ref.listen(swapPreviewProvider, (previous, next) {
      if (next is AsyncData<SwapPreview>) {
        BigInt amount = BigNumbers(swapInfo.to.decimals)
                .convertInputDoubleToBI(next.value.amount) ??
            BigInt.zero;
        toTextNotifer.value =
            convertAmountBItoDouble(amount, swapInfo.to.decimals).toString() !=
                    "-1"
                ? convertAmountBItoDouble(amount, swapInfo.to.decimals)
                    .toString()
                : "";
      }
    });

    if (swapPreview.isLoading) {
      toTextNotifer.value = "";
    }

    final canSchedule = ref.watch(canScheduleProvider);
    if (swapPreview.hasError) {
      toTextNotifer.value = "";
      errorMessage = "Amount too low!";
      showErrorMessage = true;
    }

    return NomoCard(
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      backgroundColor: context.theme.colors.surface,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NomoText(
                    "From",
                    style: context.theme.typography.b3,
                  ),
                  NomoTextButton(
                    text: "Clear All",
                    padding: const EdgeInsets.all(8),
                    textStyle: context.theme.typography.b3.copyWith(
                      color: context.theme.colors.error,
                    ),
                    onPressed: () {
                      ref.read(swapInfoProvider.notifier).clearAll();
                      toTextNotifer.value = "";
                      fromTextNotifer.value = "";
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
              SwapAssetInput(
                balanceValid: showErrorMessage,
                errorWidget: ErrorMessage(
                  errorMessage: errorMessage,
                ),
                inputActions: InputActions(
                  isFrom: true,
                  textNotifier: fromTextNotifer,
                ),
                isFrom: true,
                textNotifier: fromTextNotifer,
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: NomoButton(
                  backgroundColor: context.theme.colors.primary,
                  elevation: 2,
                  height: 40,
                  width: 40,
                  shape: BoxShape.circle,
                  child: Icon(
                    Icons.swap_vert,
                    size: 30,
                    color: context.theme.colors.onPrimary,
                  ),
                  onPressed: () {
                    ref.read(swapInfoProvider.notifier).switchFromTo();
                  },
                ),
              ),
              NomoText(
                "To",
                style: context.theme.typography.b3,
              ),
              const SizedBox(height: 24),
              SwapAssetInput(
                balanceValid: false,
                errorWidget: ErrorMessage(
                  errorMessage: errorMessage,
                ),
                inputActions: InputActions(
                  isFrom: false,
                  textNotifier: toTextNotifer,
                ),
                isFrom: false,
                textNotifier: toTextNotifer,
              ),
              const SizedBox(height: 32),
              if (!showErrorMessage && canSchedule) ...[
                const Center(
                  child: SwapPreviewDisplay(),
                ),
                const SizedBox(height: 32),
              ],
              if (swapPreview.isLoading) ...[
                Center(
                  child: Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.theme.colors.background1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 200,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
              PrimaryNomoButton(
                type: canSchedule ? ActionType.def : ActionType.nonInteractive,
                text: "Swap",
                textStyle: context.theme.typography.h2.copyWith(
                  color: context.theme.colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () async {
                  print("hello we are here!");

                  if (await ref.read(swapProvider.notifier).getQuote()) {
                    print("hello we get quote!");
                  }
                },
                height: 48,
                width: double.infinity,
                elevation: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
