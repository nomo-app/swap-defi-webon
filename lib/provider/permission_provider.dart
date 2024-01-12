import 'dart:convert';
import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/http_client.dart';

final permissionProvider = FutureProvider<bool>((ref) async {


 // final (api, _) = ref.watch(swapSchedulerProvider);

  // if (api == null || api != SwappingApi.sideshift) {
  //   return true;
  // }

  try {
    return getPermissionFromSideShift();
  } on SocketException {
    throw Exception("No Internet Connection");
  }
});

Future<bool> getPermissionFromSideShift() async {
  var response = await HTTPService.client.get(
    Uri.parse('https://sideshift.ai/api/v2/permissions'),
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    var decodedResponse = jsonDecode(response.body);

    if (decodedResponse['createShift'] == true) {
      return true;
    } else {
      throw Exception("Unsupported region");
    }
  } else {
    throw Exception("Unknown error");
  }
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
  avinocZone(
    base: "https://avinoc.one/api/v2",
    coin: "/coins",
    shift: "/shifts/fixed",
    varShift: "/shifts/variable",
    quote: "/quotes",
    history: "/shifts",
    singleHistory: "/shift",
  ),;

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
