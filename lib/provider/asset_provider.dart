import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/widgets/token.dart';
import 'dart:js_util' as js_util;
import 'package:js/js.dart';

final visibleAssetsProvider =
    FutureProvider((ref) async => await getAssetsFromNomo());

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
    print(tokens[0].name);
    return tokens;
  } catch (e) {
    print("Error: $e");
    return [];
  }
}

final fromProvider = StateProvider<Token?>(
  (ref) => null,
);

final toProvider = StateProvider<Token?>(
  (ref) => null,
);
