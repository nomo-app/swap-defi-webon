import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:swapping_webon/provider/model/http_client.dart';
import 'package:swapping_webon/provider/model/image_entity.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

const requestTimeoutLimit = Duration(seconds: 10);
typedef Json = Map<String, dynamic>;
const priceEndpoint = "https://price.zeniq.services/v2";

abstract class ImageRepository {
  static Future<ImageEntity> getImage(
    Token token,
  ) async {
    final endpoint =
        '$priceEndpoint/info/image/${token.contractAddress != null ? '${token.contractAddress}/${token.network}' : Token.getAssetName(token)}';
    try {
      final result = await (_getImage(endpoint).timeout(requestTimeoutLimit));
      return result;
    } catch (e) {
      Logger().e("Failed to fetch image from $endpoint", e, StackTrace.current);

      rethrow;
    }
  }

  static Future<ImageEntity> _getImage(String endpoint) async {
    Logger().i(
      "Fetch Image from $endpoint",
    );

    final uri = Uri.parse(endpoint);

    final response = await HTTPService.client.get(
      uri,
      headers: {"Content-Type": "application/json"},
    ).timeout(
      requestTimeoutLimit,
      onTimeout: () => throw "Timeout",
    );

    if (response.statusCode != 200) {
      throw "image_repository: Request returned status code ${response.statusCode}";
    }
    final body = jsonDecode(response.body);

    if (body == null && body is! Json) {
      throw "image_repository: Request returned null: $endpoint";
    }

    final image = ImageEntity.fromJson(body);

    if (image.isPending) throw "Image is pending";

    return image;
  }
}
