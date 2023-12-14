import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/widgets/select_asset_dialog.dart';

class SelectAsset extends StatelessWidget {
  const SelectAsset({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryNomoButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const SelectAssetDialog(),
        );
      },
      height: 40,
      width: 100,
      foregroundColor: context.theme.colors.onPrimary,
      child: const SelectAssetButtonData(),
    );
  }
}

class SelectAssetButtonData extends StatelessWidget {
  const SelectAssetButtonData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NomoText("Select"),
        SizedBox(width: 4),
        Icon(Icons.arrow_forward_ios_outlined, size: 16)
      ],
    );
  }
}
