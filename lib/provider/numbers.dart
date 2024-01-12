import 'dart:math';

class BigNumbers {
  final int decimalPlaces;

  const BigNumbers(
    this.decimalPlaces,
  );

  double add(num num1, num num2) {
    final _num1 = _shiftLeft(num1, decimalPlaces);
    final _num2 = _shiftLeft(num2, decimalPlaces);
    final result = _num1 + _num2;
    return _shiftRightBigInt(result, decimalPlaces);
  }

  double subtract(num num1, num num2) {
    final _num1 = _shiftLeft(num1, decimalPlaces);
    final _num2 = _shiftLeft(num2, decimalPlaces);
    final result = _num1 - _num2;
    return _shiftRightBigInt(result, decimalPlaces);
  }

  double multiply(num num1, num num2) {
    final _num1 = _shiftLeft(num1, decimalPlaces);
    final _num2 = _shiftLeft(num2, decimalPlaces);
    final result = _num1 * _num2;

    return _shiftRightBigInt(
      _discardRightBigInt(result, decimalPlaces),
      decimalPlaces,
    );
  }

  BigInt multiplyBI(BigInt num1, double num2) {
    final _num2 = _shiftLeft(num2, decimalPlaces);
    final result = num1 * _num2;

    return _discardRightBigInt(
      result,
      decimalPlaces,
    );
  }

  BigInt _shiftLeft(num num1, int decimalPlaces) =>
      BigInt.from(num1 * pow(10, decimalPlaces));

  BigInt _discardRightBigInt(BigInt num1, int decimalPlaces) =>
      num1 ~/ BigInt.from(pow(10, decimalPlaces));

  double _shiftRightBigInt(BigInt num1, int decimalPlaces) =>
      num1.toInt() / pow(10, decimalPlaces);
}
