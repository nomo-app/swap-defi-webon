import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/model/http_client.dart';
import 'package:swapping_webon/utils.dart/js_communication.dart';
import 'package:swapping_webon/provider/model/swap_asset.dart';
import 'package:collection/collection.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

final swapAssetsProvider =
    StateNotifierProvider<SwapAssetsNotifier, SwappingApiInfo?>((ref) {
  final assetsFromApp = ref.watch(visibleAssetsProvider);
  final assets = assetsFromApp.when<AsyncValue<List<Token>>>(
    data: (data) => AsyncData(data),
    error: (error, stackTrace) => AsyncError(error, stackTrace),
    loading: () => const AsyncLoading(),
  );

  return SwapAssetsNotifier(assets);
});

class SwapAssetsNotifier extends StateNotifier<SwappingApiInfo?> {
  final AsyncValue<List<Token>> appAssets;

  SwapAssetsNotifier(this.appAssets) : super(null) {
    loadPairs();
  }

  Future<void> loadPairs() async {
    final data = appAssets.value;

    if (data == null) return;

    final pairs = await SwapPairsService.aggregateAssets(data);
    print("This is the pairs $pairs");

    final appPairs = <SwappingApi, Iterable<Token>>{};

    for (final pair in pairs.entries) {
      appPairs[pair.key] = pair.value.where(
        (apiAsset) => data.contains(apiAsset),
      );
    }

    state = appPairs;
  }

  bool get isLoading => appAssets.isLoading;
}

enum SwappingApi {
  sideshift(
    base: "https://sideshift.ai/api/v2",
    coin: "/coins",
    shift: "/shifts/fixed",
    varShift: "/shifts/variable",
    quote: "/quotes",
    history: "/shifts",
    singleHistory: "/shift",
  ),
  ;

  final String coin;
  final String quote;
  final String shift;
  final String varShift;
  final String history;
  final String singleHistory;

  const SwappingApi({
    required String coin,
    required String quote,
    required String shift,
    required String history,
    required String singleHistory,
    required String varShift,
    required String base,
  })  : coin = "$base$coin",
        quote = "$base$quote",
        shift = "$base$shift",
        history = "$base$history",
        singleHistory = "$base$singleHistory",
        varShift = "$base$varShift";
}

typedef SwappingApiInfo = Map<SwappingApi, Iterable<Token>>;

extension SwappingApiExtensions on SwappingApiInfo {
  Set<Token> get allAssets => values.expand((element) => element).toSet();

  SwappingApiAssets whereTokenSupported(Token token) {
    final result = <Token>{};
    final apis = <SwappingApi>[];

    for (final pair in entries) {
      if (pair.value.contains(token)) {
        result.addAll(pair.value);
        apis.add(pair.key);
      }
    }

    return SwappingApiAssets(result, apis);
  }
}

class SwappingApiAssets {
  final Set<Token> allAssets;
  final List<SwappingApi> apis;

  const SwappingApiAssets(this.allAssets, this.apis);
}

const pairTimeout = Duration(seconds: 20);

abstract class SwapPairsService {
  static Future<SwappingApiInfo> aggregateAssets(List<Token> tokens) async {
    final allPairs = <SwappingApi, Iterable<Token>>{};

    print("This is the tokens $tokens");

    for (final swappingApi in SwappingApi.values) {
      print("Try to load pair from ${swappingApi.coin}");
      final assets = await loadPair(swappingApi.coin);
      final assets0 = <Token>[];
      for (final asset in assets) {
        final token = tokens
            .firstWhereOrNull((element) => element.symbol == asset.symbol);
        if (token == null) continue;
        assets0.add(token);
      }

      allPairs[swappingApi] = assets0;
    }

    return allPairs;
  }

  static Future<Iterable<SwapAsset>> loadPair(String endpoint) async {
    try {
      final response =
          await HTTPService.client.get(Uri.parse(endpoint)).timeout(
                pairTimeout,
              );

      if (response.statusCode != 200) {
        throw Exception("Failed to load pair");
      }

      final result = jsonDecode(response.body);
      if (result is! List<dynamic>) {
        throw Exception("Failed to load pair");
      }

      final assets = [
        for (final Map<String, dynamic> item in result)
          SwapAsset.fromJson(item),
      ];

      return assets;
    } catch (e, s) {
      print("Failed to load pair: $s");
      return [];
    }
  }
}
