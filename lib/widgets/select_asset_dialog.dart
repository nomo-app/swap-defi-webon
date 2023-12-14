import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/dialog/nomo_dialog.dart';
import 'package:nomo_ui_kit/components/input/textInput/nomo_input.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';

class SelectAssetDialog extends StatelessWidget {
  const SelectAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return NomoDialog(
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
            SliverAppBar(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
            ),
            const SliverToBoxAdapter(
              child: Divider(height: 12, color: Colors.transparent),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
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
