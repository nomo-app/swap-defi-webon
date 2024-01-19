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
extension AmountUtil on Amount {
  String getDisplayString([int? precision]) {
    return displayValue.toMaxPrecisionWithoutScientificNotation(
      precision ?? decimals,
    );
  } 
}

extension StringUtil on double {
  String toMaxPrecisionWithoutScientificNotation(int maxPrecision) {
    final double value = this;
    final exact = value.toExactString();
    final zeroCount = _countZeroDigits(exact);
    final nonZeroCount = value >= 1 ? (log(value) / log(10)).ceil() : 1;
    final maxLen = maxPrecision + zeroCount + nonZeroCount;
    if (maxLen < exact.length) {
      return exact.substring(0, maxLen);
    } else {
      return exact;
    }
  }
    int _countZeroDigits(String str) {
    int zeroCount = 0;

    if (str.replaceAll("-", "").indexOf('.') > 1) {
      str = str.substring(str.indexOf('.') + 1, str.length);
    }

    for (int i = 0; i < str.length; i++) {
      if (str[i] != "0" && str[i] != "-" && str[i] != "." && str[i] != ",") {
        break;
      }
      zeroCount++;
    }
    return zeroCount;
  }

   String toExactString() {
    // https://stackoverflow.com/questions/62989638/convert-long-double-to-string-without-scientific-notation-dart
    double value = this;
    var sign = "";
    if (value < 0) {
      value = -value;
      sign = "-";
    }
    var string = value.toString();
    var e = string.lastIndexOf('e');
    if (e < 0) return "$sign$string";
    var hasComma = string.indexOf('.') == 1;
    var offset = int.parse(
      string.substring(e + (string.startsWith('-', e + 1) ? 1 : 2)),
    );
    var digits = string.substring(0, 1);

    if (hasComma) {
      digits += string.substring(2, e);
    }

    if (offset < 0) {
      return "${sign}0.${"0" * ~offset}$digits";
    }
    if (offset > 0) {
      if (offset >= digits.length) {
        return sign + digits.padRight(offset + 1, "0");
      }
      return "$sign${digits.substring(0, offset + 1)}"
          ".${digits.substring(offset + 1)}";
    }
    return digits;
  }
}
