import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/buttons/text/nomo_text_button.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/asset_provider.dart';
import 'package:swapping_webon/widgets/input_actions.dart';
import 'package:swapping_webon/widgets/swap_asset_input.dart';

class SwapCard extends ConsumerStatefulWidget {
  const SwapCard({super.key});

  @override
  ConsumerState<SwapCard> createState() => _SwapCardState();
}

class _SwapCardState extends ConsumerState<SwapCard> {
  final fromTextNotifer = ValueNotifier('');
  final toTextNotifer = ValueNotifier('');

  @override
  void dispose() {
    fromTextNotifer.dispose();
    toTextNotifer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fromToken = ref.watch(fromProvider);
    final toToken = ref.watch(toProvider);

    bool showBottomInfoFrom = false;
    bool showBottomInfoTo = false;

    if (fromToken != null) {
      showBottomInfoFrom = true;
    }

    if (toToken != null) {
      showBottomInfoTo = true;
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
                      ref.read(fromProvider.notifier).state = null;
                      ref.read(toProvider.notifier).state = null;
                      toTextNotifer.value = "";
                      fromTextNotifer.value = "";
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
              SwapAssetInput(
                showBottomInfo: showBottomInfoFrom,
                inputActions: InputActions(token: fromToken, isFrom: true),
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
                    ref.read(fromProvider.notifier).state = toToken;
                    ref.read(toProvider.notifier).state = fromToken;
                  },
                ),
              ),
              NomoText(
                "To",
                style: context.theme.typography.b3,
              ),
              const SizedBox(height: 24),
              SwapAssetInput(
                showBottomInfo: showBottomInfoTo,
                inputActions: InputActions(token: toToken, isFrom: false),
                isFrom: false,
                textNotifier: toTextNotifer,
              ),
              const SizedBox(height: 64),
              PrimaryNomoButton(
                text: "Swap",
                textStyle: context.theme.typography.h2.copyWith(
                  color: context.theme.colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () => print("swap"),
                height: 48,
                width: double.infinity,
                elevation: 2,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
