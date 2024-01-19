sealed class SwapOrder {
  final String id;
  final String depositAddress;
  final String settleAddress;

  const SwapOrder({
    required this.id,
    required this.depositAddress,
    required this.settleAddress,
  });

  @override
  String toString() =>
      "id: $id; depositAddress: $depositAddress; settleAddress: $settleAddress";
}

final class VarSwapOrder extends SwapOrder {
  final double minDepositAmount;
  final double maxDepositAmount;

  const VarSwapOrder({
    required this.minDepositAmount,
    required this.maxDepositAmount,
    required super.depositAddress,
    required super.settleAddress,
    required super.id,
  });

  factory VarSwapOrder.fromJson(Map<String, dynamic> json) => VarSwapOrder(
        id: json['id'] as String,
        minDepositAmount: doubleFromString(json['depositMin'] as String),
        maxDepositAmount: doubleFromString(json['depositMax'] as String),
        depositAddress: json['depositAddress'] as String,
        settleAddress: json['settleAddress'] as String,
      );
}

final class FixedSwapOrder extends SwapOrder {
  final double settleAmount;
  final double depositAmount;
  final double rate;

  const FixedSwapOrder({
    required this.depositAmount,
    required this.settleAmount,
    required this.rate,
    required super.depositAddress,
    required super.settleAddress,
    required super.id,
  });

  factory FixedSwapOrder.fromJson(Map<String, dynamic> json) => FixedSwapOrder(
        id: json['id'] as String,
        settleAmount: doubleFromString(json['settleAmount'] as String),
        depositAddress: json['depositAddress'] as String,
        depositAmount: doubleFromString(json['depositAmount'] as String),
        rate: doubleFromString(json['rate'] as String),
        settleAddress: json['settleAddress'] as String,
      );
}

double doubleFromString(String number) => double.parse(number);
