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
    resultAsMap.forEach((element) {
      tokens.add(
        Token(
          name: getProperty(element, 'name'),
          symbol: getProperty(element, 'symbol'),
          decimals: getProperty(element, 'decimals'),
          contractAddress: getProperty(element, 'contractAddress'),
          balance: getProperty(element, 'balance'),
          network: getProperty(element, 'network'),
          receiveAddress: getProperty(element, 'receiveAddress'),
        ),
      );
    });

    // print("Token Symbol: ${tokens[0].symbol}");

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
external dynamic nomoGetAssetIcon(Args args);

@JS()
@anonymous
class Args {
  external String get symbol;
  external factory Args({String symbol});
}

Future<String> getAssetIcon(String symbol) async {
  final jsAssetsPromise = nomoGetAssetIcon(Args(symbol: symbol));

  final futureAssets = promiseToFuture(jsAssetsPromise);
  try {
    final result = await futureAssets;
    //print(result);

    return "went through";
  } catch (e) {
//    print(e);
    return '';
  }
}
