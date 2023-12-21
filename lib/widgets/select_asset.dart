import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/asset_provider.dart';
import 'package:swapping_webon/widgets/select_asset_dialog.dart';
import 'package:swapping_webon/widgets/token.dart';

class SelectAsset extends ConsumerWidget {
  final bool isFrom;
  const SelectAsset({super.key, required this.isFrom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = isFrom ? ref.watch(fromProvider) : ref.watch(toProvider);
    return PrimaryNomoButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => SelectAssetDialog(
            isFrom: isFrom,
          ),
        );
      },
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      foregroundColor: context.theme.colors.onPrimary,
      child: SelectAssetButtonData(token: token),
    );
  }
}

class SelectAssetButtonData extends StatelessWidget {
  final Token? token;

  const SelectAssetButtonData({
    super.key,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        token != null
            ? NomoText(token!.symbol)
            : const NomoText(
                "Select",
              ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_ios_outlined, size: 16)
      ],
    );
  }
}
