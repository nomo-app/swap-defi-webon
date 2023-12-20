import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/widgets/select_asset_dialog.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util' as js_util;

import 'package:swapping_webon/widgets/token.dart';

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

@JS()
external dynamic nomoGetVisibleAssets();

Future<List<Token>> getAssetsFromNomo() async {
  final jsAssetsPromise = nomoGetVisibleAssets();

  final futureAssets = js_util.promiseToFuture(jsAssetsPromise);

  try {
    final result = await futureAssets;
    final resultAsMap = js_util.getProperty(result, 'visibleAssets');
    List<Token> tokens = [];
    resultAsMap.forEach((element) {
      tokens.add(
        Token(
          name: js_util.getProperty(element, 'name'),
          symbol: js_util.getProperty(element, 'symbol'),
          decimals: js_util.getProperty(element, 'decimals'),
          contractAddress: js_util.getProperty(element, 'contractAddress'),
        ),
      );
    });

    return tokens;
  } catch (e) {
    print("Error: $e");
    return [];
  }
}
