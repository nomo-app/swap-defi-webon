import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/input/textInput/nomo_input.dart';
import 'package:nomo_ui_kit/components/loading/shimmer/loading_shimmer.dart';
import 'package:nomo_ui_kit/components/loading/shimmer/shimmer.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/utils.dart/numbers.dart';
import 'package:swapping_webon/provider/swap_preview.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/widgets/select_asset.dart';

const _kExpand = Duration(milliseconds: 300);

class SwapAssetInput extends ConsumerWidget {
  final Widget inputActions;
  final bool isFrom;
  final ValueNotifier<String> textNotifier;
  final Widget? errorWidget;
  final bool balanceValid;

  const SwapAssetInput({
    super.key,
    required this.inputActions,
    required this.isFrom,
    required this.textNotifier,
    required this.errorWidget,
    required this.balanceValid,
  });

  @override
  Widget build(BuildContext context, ref) {
    final tokenInfo = ref.watch(swapInfoProvider);
    final tokenSymbol = isFrom ? tokenInfo.from.symbol : tokenInfo.to.symbol;
    final showBottomInfo = tokenSymbol != '';
    final shwoError = balanceValid;
    final swapPreview = ref.watch(swapPreviewProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.theme.colors.background2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NomoInput(
            trailling: swapPreview.isLoading
                ? Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: context.theme.colors.background1,
                        ),
                        width: 100,
                        height: 20,
                      ),
                    ),
                  )
                : null,
            valueNotifier: textNotifier,
            onChanged: (value) {
              final changedValue = double.tryParse(value);

              final bigNumberToSet = BigNumbers(
                      isFrom ? tokenInfo.from.decimals : tokenInfo.to.decimals)
                  .convertInputDoubleToBI(changedValue);

              if (bigNumberToSet != null) {
                if (isFrom) {
                  ref.read(swapPreviewProvider.notifier).switchEdit(true);
                  ref
                      .read(swapInfoProvider.notifier)
                      .setFromAmount(bigNumberToSet);
                } else {
                  ref.read(swapPreviewProvider.notifier).switchEdit(false);
                  ref
                      .read(swapInfoProvider.notifier)
                      .setToAmount(bigNumberToSet);
                }
              }
            },
            selectedBorder: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
            borderRadius: _kBorderRadius(showBottomInfo),
            background: context.theme.colors.background2,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            style: context.theme.typography.b3,
            placeHolderStyle: context.theme.typography.b3,
            leading: SelectAsset(
              isFrom: isFrom,
            ),
            textAlign: TextAlign.end,
            padding: const EdgeInsets.only(
              left: 4,
              right: 12,
              top: 12,
              bottom: 12,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+([.]\d{0,4})?')),
            ],
          ),
          if (showBottomInfo)
            AnimatedContainer(
              height: showBottomInfo ? 32 : 0,
              duration: _kExpand,
              decoration: BoxDecoration(
                color: context.theme.colors.background2,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 12,
              ),
              child: AnimatedOpacity(
                opacity: showBottomInfo ? 1 : 0,
                duration: _kExpand,
                child: inputActions,
              ),
            ),
          if (shwoError)
            AnimatedContainer(
              height: showBottomInfo ? 42 : 0,
              duration: _kExpand,
              decoration: BoxDecoration(
                color: context.theme.colors.error,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 8,
              ),
              child: AnimatedOpacity(
                opacity: showBottomInfo ? 1 : 0,
                duration: _kExpand,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    errorWidget!,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  BorderRadiusGeometry _kBorderRadius(bool showBottomInfo) {
    if (showBottomInfo) {
      return const BorderRadius.vertical(
        top: Radius.circular(12),
      );
    }

    return const BorderRadius.all(
      Radius.circular(12),
    );
  }
}
