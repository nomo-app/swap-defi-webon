import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/dialog/nomo_dialog.dart';
import 'package:nomo_ui_kit/components/input/textInput/nomo_input.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/asset_provider.dart';
import 'package:swapping_webon/provider/filter_provider.dart';
import 'package:swapping_webon/widgets/wallet_widget.dart';

class SelectAssetDialog extends ConsumerWidget {
  final bool isFrom;
  const SelectAssetDialog({required this.isFrom, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(visibleAssetsProvider);

    final filter = ref.watch(filterProvider);

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
            const SearchField(),
            const SliverToBoxAdapter(
              child: Divider(height: 12, color: Colors.transparent),
            ),
            tokens.when(
              data: (data) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final token = data[index];
                    final widget = WalletWidget(
                      token: token,
                      onTap: () {
                        Navigator.of(context).pop(token);
                        if (isFrom) {
                          ref.read(fromProvider.notifier).state = token;
                        } else {
                          ref.read(toProvider.notifier).state = token;
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
                  childCount: data.length,
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Text(error.toString()),
              ),
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends ConsumerWidget {
  const SearchField({
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
