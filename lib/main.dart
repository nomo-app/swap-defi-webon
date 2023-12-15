import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/nomo_ui_kit_base.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/routes.dart';
import 'package:swapping_webon/theme/theme.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void callJsFunction() async {
  final containtsJSChannel = js.context.hasProperty('NOMOJSChannel');
  print(js.context);
  print('containtsJSChannel: $containtsJSChannel');

  if (containtsJSChannel) {
    final js.JsObject promise =
        js.context.callMethod('getCurrentNomoTheme', []);
    print(promise);
    final future = promiseToFuture(promise);
    final js.JsObject result = await future;

    // call json stringify method on result
    final containsJSON = js.context.hasProperty('JSON');
    print('containsJSON: $containsJSON');
    final jsonString =
        js.context['JSON'].callMethod('stringify', [result]) as String;

    final json = jsonDecode(jsonString) as JsonMap;

    print(json);
  }
}

// void sendNomoAssets() async {
//   final object = js.JsObject.jsify({
//     "assetSymbol": "ETH",
//     "targetAddress": "test",
//     "amount": "1",
//   });

//   print(object);

//   final result = await callAsyncMethod('nomoSendAssets', [object]);

//   print(result);
// }

Future<dynamic> callAsyncMethod(String methodName, [List? args]) async {
  final promise = js.context.callMethod(methodName, args);

  print(promise);

  final future = promiseToFuture(promise);

  print(future);

  try {
    final result = await future;

    print(result);

    return result;
  } catch (e) {
    print(toJson(e as js.JsObject));
    print("Error: $e");
    return null;
  }
}

JsonMap toJson(js.JsObject result) {
  final jsonString =
      js.context['JSON'].callMethod('stringify', [result]) as String;

  return jsonDecode(jsonString) as JsonMap;
}

Future<T> promiseToFuture<T>(js.JsObject promise) {
  var completer = Completer<T>();

  promise.callMethod('then', [
    (result) => completer.complete(result),
    (error) => completer.completeError(error)
  ]);

  return completer.future;
}

typedef JsonMap = Map<String, dynamic>;

void main() {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return NomoApp(
      sizingThemeBuilder: (width) => switch (width) {
        < 480 => sizingSmall,
        < 1080 => sizingMedium,
        _ => sizingLarge,
      },
      theme: NomoThemeData(
        colorTheme: ColorMode.LIGHT.theme,
        sizingTheme: SizingMode.LARGE.theme,
        textTheme: typography,
        constants: constants,
      ),
      supportedLocales: const [Locale('en', 'US')],
      routes: routes,
    );
  }
}
