import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:js/js_util.dart';
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

      tokens.add(
        Token(
          name: getProperty(element, 'name'),
          symbol: getProperty(element, 'symbol'),
          decimals: getProperty(element, 'decimals'),
          contractAddress: getProperty(element, 'contractAddress'),
          balance: balance,
          network: getProperty(element, 'network'),
          receiveAddress: getProperty(element, 'receiveAddress'),
        ),
      );
    });

    return tokens;
  } catch (e) {
    return [];
  }
}

final fromProvider = StateProvider<Token?>(
  (ref) => null,
);

final toProvider = StateProvider<Token?>(
  (ref) => null,
);

@JS()
@anonymous
class Args {
  external String get symbol;
  external factory Args({String symbol});
}

@JS()
external dynamic nomoGetAssetIcon(Args args);

Future<String> getAssetIcon(String symbol) async {
  final jsAssetsPromise = nomoGetAssetIcon(Args(symbol: symbol));

  final futureAssetIcon = promiseToFuture(jsAssetsPromise);
  try {
    final result = await futureAssetIcon;
    final assetLocationString = getProperty(result, 'small');
    print(assetLocationString);

    return assetLocationString;
  } catch (e) {
    return 'no icon found: $e';
  }
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
