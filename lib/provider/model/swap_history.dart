import 'package:swapping_webon/provider/model/tx_history_entity.dart';

class HistoryEntity {
  final String fromSymbol;
  final String toSymbol;
  final TransactionEntitySwapHistory transaction;

  double? get amount => transaction.amount;

  const HistoryEntity({
    required this.fromSymbol,
    required this.toSymbol,
    required this.transaction,
  });
}
