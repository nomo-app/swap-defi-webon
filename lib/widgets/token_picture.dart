import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/loading/shimmer/loading_shimmer.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/utils.dart/js_communication.dart';
import 'package:swapping_webon/provider/model/token.dart';

class TokenPicture extends ConsumerWidget {
  final String heroKey;
  final double size;
  final Token token;

  const TokenPicture({
    super.key,
    required this.token,
    this.size = 48,
    String? heroKey,
  }) : heroKey = heroKey ?? "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(imageProvider(token));

    return asset.when<Widget>(
      data: (data) => Hero(
        tag: heroKey,
        child: Image.network(
          data.small,
          height: size,
          width: size,
        ),
      ),
      error: (_, __) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.theme.colors.background3,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      loading: () => ShimmerLoading(
        isLoading: true,
        child: Container(
          width: size,
          height: size,
          color: context.theme.colors.background1,
        ),
      ),
    );
  }
}
