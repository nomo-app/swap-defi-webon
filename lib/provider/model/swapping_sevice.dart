import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:swapping_webon/provider/model/http_client.dart';
import 'package:swapping_webon/provider/permission_provider.dart';
import 'package:swapping_webon/provider/model/swap_order.dart';
import 'package:swapping_webon/provider/model/swap_quote.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

const sideShiftAffiliateId = "73fsQlpZN5";

abstract class SwappingService {
  static Future<SwapQuote> fetchQuote(
    String endpoint,
    Token assetFromItem,
    Token assetToItem,
    BigInt? inputAmount,
    BigInt? outputAmount,
  ) async {
    assert(inputAmount != null || outputAmount != null);

    final inputAmount0 =
        convertAmountBItoDouble(inputAmount, assetFromItem.decimals);
    final outputAmount0 =
        convertAmountBItoDouble(outputAmount, assetToItem.decimals);

    try {
      var response = await HTTPService.client.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "depositCoin": assetFromItem.symbol,
            "settleCoin": assetToItem.symbol,
            "depositNetwork": assetFromItem.network,
            "settleNetwork": assetToItem.network,
            "depositAmount": inputAmount0,
            "settleAmount": outputAmount0
          },
        ),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode != 201) {
        String errorMessage = json['error']['message'];
        String? error;

        switch (errorMessage) {
          case "Invalid coin":
            error = "Invalid Pair";
            break;
          case "Rate limit exceeded.":
            error = "Rate limit exceeded.";
            break;
        }

        //Error containts
        if (errorMessage.contains("Amount too low")) {
          error = "Amount too low";
        }

        if (errorMessage.contains("Amount too high")) {
          error = "Amount too high";
        }

        if (errorMessage.contains("decimals too high")) {
          error = "Decimals too high";
        }

        if (error == null) {
          print("Error: $errorMessage");

          error = "SwapError.UNDEFINED";
        }

        print(
            "SideShift Quote [from:$assetFromItem;to:$assetToItem] Error: $error");

        throw Exception(error);
      }

      return SwapQuote.fromJson(json);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Future<FixedSwapOrder> postFixedOrder(
    String endpoint,
    String quoteId, {
    required Token to,
    required Token from,
    bool useDevWallet = false,
  }) async {
    print("endpoint: $endpoint");
    print("quoteId: $quoteId");
    print("to: $to");
    print("from: $from");

    if (quoteId != "0") {
      final isSideShift = endpoint == SwappingApi.sideshift.shift;
      const affiliateId = sideShiftAffiliateId;

      var multiChainReceiveAddressTo =
          await WebonKitDart.getMultiChainReceiveAddress(
                symbol: to.symbol,
              ) ??
              "env[DEVADDRESS]";

      final multiChainReceiveAddressFrom =
          await WebonKitDart.getMultiChainReceiveAddress(
                symbol: from.symbol,
              ) ??
              "env[DEVADDRESS]";

      print("multiChainReceiveAddressTo: $multiChainReceiveAddressTo");
      print("multiChainReceiveAddressFrom: $multiChainReceiveAddressFrom");

      final settleAddress = multiChainReceiveAddressTo;
      final refundAddress = multiChainReceiveAddressFrom;

      final response = await HTTPService.client.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "quoteId": quoteId,
            "settleAddress": settleAddress,
            "refundAddress": refundAddress,
            if (isSideShift) "affiliateId": affiliateId,
          },
        ),
      );
      if (response.statusCode == 429) {
        throw Exception("Rate limit exceeded.");
      }
      final json = jsonDecode(response.body);
      if (response.statusCode != 201) {
        final error = json['error']['message'];

        if (error ==
            "Too many open orders. Make deposits to existing orders instead.") {
          throw Exception("Rate limit exceeded.");
        }
        print("SideShift Order Error: $error");

        throw Exception(error);
      }
      return FixedSwapOrder.fromJson(json);
    }
    throw Exception("Invalid Quote ID");
  }

  // static Future<VarSwapOrder> postVarOrder(
  //   String endpoint, {
  //   required Token to,
  //   required Token from,
  //   bool useDevWallet = false,
  // }) async {
  //   final affiliateId = sideShiftAffiliateId;

  //   final settleAddress = "getMultiChainReceiveAddress(to)";
  //   final refundAddress = "getMultiChainReceiveAddress(from)";
  //   final body = {
  //     "settleAddress": settleAddress,
  //     "refundAddress": refundAddress,
  //     "depositNetwork": from.network,
  //     "settleNetwork": to.network,
  //     "depositCoin": from.symbol.toLowerCase(),
  //     "settleCoin": to.symbol.toLowerCase(),
  //     "affiliateId": affiliateId,
  //   };
  //   final response = await HTTPService.client.post(
  //     Uri.parse(endpoint),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(body),
  //   );
  //   if (response.statusCode == 429) {
  //     throw Exception("Rate limit exceeded.");
  //   }
  //   final json = jsonDecode(response.body);
  //   if (response.statusCode != 201) {
  //     final error = json['error']['message'];

  //     if (error ==
  //         "Too many open orders. Make deposits to existing orders instead.") {
  //       throw Exception("Rate limit exceeded.");
  //     }
  //     throw Exception(error);
  //   }
  //   return VarSwapOrder.fromJson(json);
  // }
}

double? convertAmountBItoDouble(BigInt? amount, int decimals) {
  if (amount == null) {
    return null;
  }
  double amountDouble = amount.toDouble() / pow(10, decimals);
  return amountDouble;
}
