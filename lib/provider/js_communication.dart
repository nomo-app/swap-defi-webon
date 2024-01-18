import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:js/js_util.dart';
import 'package:swapping_webon/provider/image_repository.dart';
import 'package:swapping_webon/widgets/image_entity.dart';
import 'package:swapping_webon/widgets/token.dart';
import 'package:js/js.dart';

final visibleAssetsProvider =
    FutureProvider((ref) async => await getAssetsFromNomo());

@JS()
external dynamic nomoGetVisibleAssets();

Future<List<Token>> getAssetsFromNomo() async {
  final jsAssetsPromise = nomoGetVisibleAssets();

  final futureAssets = promiseToFuture(jsAssetsPromise);

  try {
    final result = await futureAssets;
    final resultAsMap = getProperty(result, 'visibleAssets');
    List<Token> tokens = [];
    resultAsMap.forEach((element) async {
      var balance = getProperty(element, 'balance');
      balance ??= await getBalance(getProperty(element, 'symbol'));
      final token = Token(
        name: getProperty(element, 'name'),
        symbol: getProperty(element, 'symbol'),
        decimals: getProperty(element, 'decimals'),
        contractAddress: getProperty(element, 'contractAddress'),
        balance: balance,
        network: getProperty(element, 'network'),
        receiveAddress: getProperty(element, 'receiveAddress'),
      );
      tokens.add(
        token,
      );
    });

    return tokens;
  } catch (e) {
    return [];
  }
}

@JS()
@anonymous
class Args {
  external String get symbol;
  external factory Args({String symbol});
}

@JS()
external dynamic nomoGetBalance(Args args);

Future<String> getBalance(String symbol) async {
  final jsBalancePromise = nomoGetBalance(Args(symbol: symbol));

  final futureBalance = promiseToFuture(jsBalancePromise);
  try {
    final result = await futureBalance;
    final balanceString = getProperty(result, 'balance');

    return balanceString;
  } catch (e) {
    return 'no balance found: $e';
  }
}

@JS()
external dynamic nomoGetAssetPrice(Args args);

Future<AssetPrice> getAssetPrice(String symbol) async {
  final jsPricePromise = nomoGetAssetPrice(Args(symbol: symbol));

  final futurePrice = promiseToFuture(jsPricePromise);
  try {
    final result = await futurePrice;
    final priceString = getProperty(result, 'price');
    final currencyDisplayName = getProperty(result, 'currencyDisplayName');
    print('priceString: $priceString');
    print('currencyDisplayName: $currencyDisplayName');

    return {
      'price': priceString,
      'currencyDisplayName': currencyDisplayName,
    };
  } catch (e) {
    throw Exception('no price found: $e');
  }
}

typedef AssetPrice = Map<String, dynamic>;

final priceProvider =
    FutureProvider.family<AssetPrice, String>((ref, symbol) async {
  return await getAssetPrice(symbol);
});

final imageProvider =
    StateNotifierProvider.family<ImageNotifier, AsyncValue<ImageEntity>, Token>(
        (ref, token) {
  return ImageNotifier(token: token);
});

class ImageNotifier extends StateNotifier<AsyncValue<ImageEntity>> {
  final Token token;

  String get key => "image_${token.name}_${token.symbol}";

  ImageNotifier({required this.token}) : super(AsyncLoading()) {
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