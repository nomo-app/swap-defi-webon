import 'dart:convert';
import 'package:swapping_webon/provider/http_client.dart';
import 'package:swapping_webon/widgets/image_entity.dart';
import 'package:swapping_webon/widgets/token.dart';

const REQUEST_TIMEOUT_LIMIT = Duration(seconds: 10);
typedef Json = Map<String, dynamic>;
const PRICE_ENDPOINT = "https://price.zeniq.services/v2";

abstract class ImageRepository {
  static Future<ImageEntity> getImage(
    Token token,
  ) async {
    final endpoint =
        '$PRICE_ENDPOINT/info/image/${token.contractAddress != null ? '${token.contractAddress}/${token.network}' : Token.getAssetName(token)}';
    try {
      final result = await (_getImage(endpoint).timeout(REQUEST_TIMEOUT_LIMIT));
      return result;
    } catch (e, s) {
      print(
        "Failed to fetch image from $endpoint",
      );
      rethrow;
    }
  }

  static Future<ImageEntity> _getImage(String endpoint) async {
    print(
      "Fetch Image from $endpoint",
    );

    final uri = Uri.parse(endpoint);

    final response = await HTTPService.client.get(
      uri,
      headers: {"Content-Type": "application/json"},
    ).timeout(
      REQUEST_TIMEOUT_LIMIT,
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
