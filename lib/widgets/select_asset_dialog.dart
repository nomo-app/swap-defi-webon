import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/dialog/nomo_dialog.dart';
import 'package:nomo_ui_kit/components/input/textInput/nomo_input.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/swap_asstes_provider.dart';
import 'package:swapping_webon/provider/swap_provider.dart';
import 'package:swapping_webon/provider/model/swapinfo.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/provider/model/token.dart';
import 'package:swapping_webon/widgets/wallet_widget.dart';

final filterProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

class SelectAssetDialog extends ConsumerWidget {
  final bool isFrom;
  const SelectAssetDialog({required this.isFrom, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapInfo = ref.watch(swapInfoProvider);
    final filter = ref.watch(filterProvider);
    final pairs = ref.watch(swapAssetsProvider);

    Token? selectedAsset = isFrom ? swapInfo.to : swapInfo.from;
    if (selectedAsset == nullToken) selectedAsset = null;

    final List<Token> tokens;

    final isLoading = ref.watch(swapAssetsProvider.notifier).isLoading;
    if (selectedAsset == null) {
      tokens = pairs?.allAssets.toList() ?? [];
    } else {
      final info = pairs?.whereTokenSupported(selectedAsset);
      tokens = info?.allAssets.toList() ?? [];
      print("This is the tokens $tokens");

      final api = info?.apis.first;

      assert(api != null, "No api found for $selectedAsset");

      Future.microtask(() {
        ref.read(swapSchedulerProvider.notifier).setSwappingApi(api!);
      });
    }

    ValueNotifier<String> valueNotifier = ValueNotifier("");

    valueNotifier.addListener(() {
      ref.read(filterProvider.notifier).state =
          valueNotifier.value.toLowerCase();
    });

    return NomoDialog(
      backgroundColor: context.theme.colors.surface,
      titleStyle: context.theme.typography.h2,
      maxWidth: 450,
      title: "Select Asset",
      content: SizedBox(
        height: 450,
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Divider(height: 12, color: Colors.transparent),
            ),
            SearchField(
              valueNotifier: valueNotifier,
            ),
            const SliverToBoxAdapter(
              child: Divider(height: 12, color: Colors.transparent),
            ),
            if (isLoading)
              const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final token = tokens[index];
                    final widget = WalletWidget(
                      token: token,
                      onTap: () {
                        Navigator.of(context).pop(token);
                        if (isFrom) {
                          ref.read(swapInfoProvider.notifier).setFrom(token);
                        } else {
                          ref.read(swapInfoProvider.notifier).setTo(token);
                        }
                      },
                    );
                    if (filter == null || filter.isEmpty) return widget;
                    if (token.name!.toLowerCase().contains(filter) ||
                        token.symbol.toLowerCase().contains(filter)) {
                      return widget;
                    }
                    return const SizedBox.shrink();
                  },
                  childCount: tokens.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends ConsumerWidget {
  final ValueNotifier<String> valueNotifier;

  const SearchField({
    required this.valueNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      leading: const SizedBox(),
      leadingWidth: 0,
      centerTitle: false,
      snap: true,
      floating: true,
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: NomoInput(
          valueNotifier: valueNotifier,
          background: context.theme.colors.surface,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          border: Border.all(
            color: context.theme.colors.background3,
            width: 1,
          ),
          leading: Icon(
            Icons.search,
            color: context.theme.colors.foreground1,
          ),
          placeHolder: "Search",
        ),
      ),
    );
  }
}
