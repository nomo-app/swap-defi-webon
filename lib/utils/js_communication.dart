import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/images/image_repository.dart';
import 'package:swapping_webon/provider/model/image_entity.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

final visibleAssetsProvider =
    FutureProvider((ref) async => await WebonKitDart.getVisibleAssets());

final priceProvider =
    FutureProvider.family<AssetPrice, String>((ref, symbol) async {
  return await WebonKitDart.getAssetPrice(
    symbol: symbol,
  );
});

final imageProvider =
    StateNotifierProvider.family<ImageNotifier, AsyncValue<ImageEntity>, Token>(
        (ref, token) {
  return ImageNotifier(token: token);
});

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity>> {
  final Token token;

  String get key => "image_${token.name}_${token.symbol}";

  ImageNotifier({required this.token}) : super(const AsyncLoading()) {
    loadImage();
  }

  void loadImage({String? network}) async {
    try {
      final result = await ImageRepository.getImage(
        token,
      );
      state = AsyncData(result);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
