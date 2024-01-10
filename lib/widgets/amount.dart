import 'dart:math';

class Amount {
  final BigInt value;
  final int decimals;

  const Amount({
    required this.value,
    required this.decimals,
  });

  Amount.num({
    required num value,
    required this.decimals,
  }) : value = BigInt.from(value * pow(10, decimals));

  Amount.fromString({
    required String value,
    required this.decimals,
  }) : value = BigInt.parse(value);

  Amount.zero()
      : value = -1.toBI,
        decimals = 0;

  static Amount get empty => Amount(value: BigInt.from(0), decimals: 0);

  double get displayValue {
    return value / BigInt.from(10).pow(decimals);
  }

  Amount copyWith({
    BigInt? value,
    int? decimals,
  }) {
    if (value == null && decimals == null) return this;

    return Amount(
      value: value ?? this.value,
      decimals: decimals ?? this.decimals,
    );
  }

  bool isOther(Amount other) {
    return value == other.value && decimals == other.decimals;
  }

  @override
  List<Object?> get props => [value, decimals];

  @override
  String toString() {
    return 'Amount{value: $value, decimals: $decimals}: $displayValue';
  }
}

extension SatoshiUtils on num {
  BigInt get toSatoshi {
    return BigInt.from(this * 100000000);
  }

  BigInt get toBI {
    return BigInt.from(this);
  }

  bool isUint(int bit) {
    return (this >= 0 && this <= pow(2, bit) - 1);
  }
}
