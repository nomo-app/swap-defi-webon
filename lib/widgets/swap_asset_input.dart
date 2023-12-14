import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nomo_ui_kit/components/input/textInput/nomo_input.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/widgets/select_asset.dart';

class SwapAssetInput extends StatelessWidget {
  const SwapAssetInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.theme.colors.background2,
          ),
          height: 100,
        ),
        Positioned(
          top: 12,
          left: 5,
          right: 5,
          bottom: 5,
          child: NomoInput(
            margin: const EdgeInsets.all(6),
            background: context.theme.colors.surface,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            placeHolder: "0",
            maxLines: 1,
            border: Border.all(
              color: context.theme.colors.background3,
              width: 1,
            ),
            style: context.theme.typography.b3,
            placeHolderStyle: context.theme.typography.b3,
            leading: SelectAsset(),
            textAlign: TextAlign.end,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 12,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
            ],
          ),
        ),
      ],
    );
  }
}
