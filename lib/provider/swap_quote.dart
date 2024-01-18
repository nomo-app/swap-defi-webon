import 'package:swapping_webon/provider/swap_order.dart';

class SwapQuote {
  final String id;

  final double settleAmount;

  final double depositAmount;

  final double rate;

  const SwapQuote({
    required this.id,
    required this.settleAmount,
    required this.depositAmount,
    required this.rate,
  });

  factory SwapQuote.fromJson(Map<String, dynamic> json) => SwapQuote(
        id: json['id'] as String,
        settleAmount: doubleFromString(json['settleAmount'] as String),
        depositAmount: doubleFromString(json['depositAmount'] as String),
        rate: doubleFromString(json['rate'] as String),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'settleAmount': settleAmount,
        'depositAmount': depositAmount,
        'rate': rate,
      };

  @override
  String toString() =>
      "id: $id; settleAmount: $settleAmount; depositAmount: $depositAmount; rate: $rate";
}
