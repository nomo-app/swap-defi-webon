import 'package:flutter/widgets.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/buttons/secondary/nomo_secondary_button.dart';
import 'package:nomo_ui_kit/components/dialog/nomo_dialog.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/swap_provider.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class SendAssetFallBackDialog extends StatelessWidget {
  final FallBackAsset args;

  const SendAssetFallBackDialog({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return NomoDialog(
      maxWidth: 300,
      title: "Send assts fallback",
      titleStyle: context.typography.h2,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NomoText(
            "Are you sure you want to send the asset?",
            style: context.typography.b2,
          ),
          const SizedBox(height: 18),
          NomoText(
            "Token: ${args.symbol}",
            style: context.typography.b3,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          NomoText(
            "Amount: ${args.amount.displayValue}",
            style: context.typography.b2,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 8),
          NomoText(
            "Target address: ${args.targetAddress}",
            style: context.typography.b2,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      actions: [
        SecondaryNomoButton(
          padding: const EdgeInsets.all(12),
          text: "Cancel",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const Spacer(),
        PrimaryNomoButton(
          padding: const EdgeInsets.all(12),
          text: "Confirm",
          onPressed: () async {},
        ),
      ],
    );
  }
}
