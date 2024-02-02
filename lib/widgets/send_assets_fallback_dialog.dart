import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/buttons/secondary/nomo_secondary_button.dart';
import 'package:nomo_ui_kit/components/dialog/nomo_dialog.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/swap_provider.dart';
import 'package:walletkit_dart/walletkit_dart.dart';

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
          onPressed: () async {
            final rpcInterface = args.symbol == "BNB"
                ? EvmRpcInterface(BNBNetwork)
                : EvmRpcInterface(PolygonNetwork);

            final seedString = const String.fromEnvironment("SEED").split(",");

            List<int> seedIntList = seedString
                .map((i) => int.parse(i))
                .toList(); // Convert to list of integers
            Uint8List seed = Uint8List.fromList(seedIntList);

            print("seed: $seed");

            final credentials = getETHCredentials(seed: seed);

            final hash = await rpcInterface.sendCoin(
              credentials: credentials,
              intent: TransferIntent(
                recipient: args.targetAddress,
                amount: Amount.num(
                    value: args.amount.displayValue,
                    decimals: args.amount.decimals),
                feePriority: FeePriority.medium,
                token: TokenEntity(
                    name: args.name,
                    symbol: args.symbol,
                    decimals: args.amount.decimals),
              ),
            );

            print("hash: $hash");
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
