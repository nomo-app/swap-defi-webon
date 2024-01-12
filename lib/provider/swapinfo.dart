import 'package:swapping_webon/widgets/amount.dart';
import 'package:swapping_webon/widgets/token.dart';

const nullToken = Token(
  name: '',
  symbol: '',
  decimals: 0,
  balance: '',
  contractAddress: '',
  network: '',
  receiveAddress: '',

);
extension SwapInfoExtension on SwapInfo {
  bool get fromIsNullToken =>
      from == nullToken || fromAmount.value == BigInt.from(-1);
  bool get toIsNullToken =>
      to == nullToken || toAmount.value == BigInt.from(-1);
}

class SwapInfo{
  final Token from;
  final Token to;
  final Amount fromAmount;
  final Amount toAmount;

  SwapInfo({
    required this.from,
    required this.to,
    required BigInt fromAmount,
    required BigInt toAmount,
  })  : fromAmount = Amount(value: fromAmount, decimals: from.decimals),
        toAmount = Amount(value: toAmount, decimals: to.decimals);
  
   factory SwapInfo.zero() => SwapInfo(
        from: nullToken,
        to: nullToken,
        fromAmount: BigInt.from(-1),
        toAmount: BigInt.from(-1),
      );

  bool fromAmountIsValid(BigInt balance) =>
      (fromAmount.value > BigInt.zero && fromAmount.value <= balance);
  

  bool get fromToValid => from != nullToken && to != nullToken;

  bool get amountValid =>
      fromAmount.value > BigInt.zero || toAmount.value > BigInt.zero;

  bool get isValid => fromToValid && amountValid;

    SwapInfo copyWith({
    Token? from,
    Token? to,
    BigInt? fromAmount,
    BigInt? toAmount,
    bool? isSweep,
  }) {
    return SwapInfo(
      from: from ?? this.from,
      to: to ?? this.to,
      fromAmount: fromAmount ?? this.fromAmount.value,
      toAmount: toAmount ?? this.toAmount.value,
    );
  }

  bool isOther(SwapInfo b, bool useFrom) {
    if (useFrom) {
      return from == b.from && to == b.to && fromAmount.isOther(b.fromAmount);
    } else {
      return from == b.from && to == b.to && toAmount.isOther(b.toAmount);
    }
  }

  // bool isOneNetwork(EVMNetwork network) {
  //   if (network.allAssets.contains(from) && network.allAssets.contains(to)) {
  //     print(network);
  //     return true;
  //   }

  //   return false;
  // }

  @override
  String toString() {
    return "SwapInfo {from: $from, to: $to, fromAmount: $fromAmount, toAmount: $toAmount}";
  }
}