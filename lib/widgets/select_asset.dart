import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/widgets/select_asset_dialog.dart';

class SelectAsset extends StatelessWidget {
  const SelectAsset({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryNomoButton(
      text: "Select",
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SelectAssetDialog(),
        );
      },
      height: 40,
      width: 100,
      foregroundColor: context.theme.colors.onPrimary,
    );
  }
}
