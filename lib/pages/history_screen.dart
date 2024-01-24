import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_router/nomo_router.dart';
import 'package:nomo_ui_kit/components/buttons/secondary/nomo_secondary_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/icons/nomo_icons.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/swap_history_provider.dart';
import 'package:swapping_webon/widgets/history_item.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    if (history.hasValue) {
      print(history.value);
    }

    // final assetsFromApp = ref.watch(visibleAssetsProvider);

    // List<Token> assets = [];
    // if (assetsFromApp.hasValue) {
    //   assets = assetsFromApp.value!;
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            SecondaryNomoButton(
              shape: BoxShape.rectangle,
              padding: const EdgeInsets.all(8),
              iconSize: 22,
              icon: NomoIcons.arrowLeft,
              onPressed: () => NomoNavigator.of(context).pop(),
            ),
            const Spacer(),
            NomoText(
              "History",
              style: context.theme.typography.h2,
              fontWeight: FontWeight.bold,
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 48),
        if (history.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (history.hasError)
          const Center(child: Text("Error"))
        else if (history.hasValue)
          Expanded(
            child: ListView.builder(
              itemCount: history.value?.length,
              itemBuilder: (context, index) {
                return HistoryItem(
                  item: history.value![index],
                );
              },
            ),
          ),
      ],
    );
  }
}
