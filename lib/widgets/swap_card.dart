import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/asset_provider.dart';
import 'package:swapping_webon/widgets/input_actions.dart';
import 'package:swapping_webon/widgets/swap_asset_input.dart';

class SwapCard extends ConsumerWidget {
  const SwapCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NomoText(
              "From",
              style: context.theme.typography.b3,
            ),
            const SizedBox(height: 16),
            SwapAssetInput(
                showBottomInfo: showBottomInfoFrom,
                inputActions: InputActions()),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: NomoButton(
                backgroundColor: context.theme.colors.surface,
                elevation: 2,
                height: 40,
                width: 40,
                shape: BoxShape.circle,
                child: const Icon(Icons.swap_vert, size: 30),
                onPressed: () => print("swap assets"),
              ),
            ),
            NomoText(
              "To",
              style: context.theme.typography.b3,
            ),
            const SizedBox(height: 16),
            SwapAssetInput(
                showBottomInfo: showBottomInfoTo, inputActions: InputActions()),
            const Spacer(),
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
    );
  }
}
