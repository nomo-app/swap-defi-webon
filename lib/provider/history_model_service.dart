import 'dart:convert';

import 'package:swapping_webon/provider/model/history_model.dart';
import 'package:swapping_webon/provider/model/http_client.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

abstract class HistoryModelService {
  static Future<List<HistoryModel>> getHistory(
    String endpoint,
    String prefix,
  ) async {
    final ids = await _getIdForPrefix(prefix);

    List<String> idblocks = [];

    String idBlock = '';
    for (var i = 0; i < ids.length; i++) {
      idBlock += ids[i];

      if (i != ids.length - 1 && (i + 1) % 10 != 0) {
        idBlock += ',';
      }

      if ((i + 1) % 10 == 0) {
        idblocks.add(idBlock);
        idBlock = '';
      }
    }
    if (idBlock.isNotEmpty) idblocks.add(idBlock);

    List<HistoryModel> list = [];

    try {
      for (String ids in idblocks) {
        // int i = 0;

        final response = await HTTPService.client.get(
          Uri.parse('$endpoint?ids=$ids'),
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          var decodedResponse = jsonDecode(response.body);
          for (var item in decodedResponse) {
            final model = HistoryModel.fromJson(item, prefix);
            if (model != null) list.add(model);
            // i++;
          }
        } else {
          throw Exception("Order not found");
        }
      }

      return list.reversed.toList();
    } catch (e) {
      return [];
    }
  }

  static Future<HistoryModel?> singleHistory(
    String endpoint,
    String id,
    String prefix,
  ) async {
    final response = await HTTPService.client.get(
      Uri.parse('$endpoint/$id'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return HistoryModel.fromJson(decodedResponse, prefix);
    } else {
      throw Exception("Order not found");
    }
  }

  static Future<List<String>> _getIdForPrefix(String prefix) async {
    List<String> orderIDs = [];
    int count = 0;
    while (true) {
      final result = await WebonKitDart.getLocalStorage(
          key: "$prefix/swap_history/$count");
      if (result == null) {
        break;
      }
      count++;
      orderIDs.add(result);
    }

    return orderIDs;
  }
}
