import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/widgets/select_asset_dialog.dart';
import 'package:swapping_webon/widgets/token.dart';
import 'package:swapping_webon/widgets/token_picture.dart';

class SelectAsset extends ConsumerWidget {
  final bool isFrom;
  const SelectAsset({super.key, required this.isFrom});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(swapInfoProvider);
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
      child: SelectAssetButtonData(token: isFrom ? token.from : token.to),
    );
  }
}

class SelectAssetButtonData extends StatelessWidget {
  final Token token;

  const SelectAssetButtonData({
    super.key,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        token.symbol != ''
            ? Row(
                children: [
                  TokenPicture(
                    token: token,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  NomoText(token.symbol, fontSize: 18, minFontSize: 12),
                ],
              )
            : const NomoText(
                fontSize: 18,
                minFontSize: 12,
                "Select",
              ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_ios_outlined, size: 16)
      ],
    );
  }
}
