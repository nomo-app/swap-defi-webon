import 'package:intl/intl.dart';

class TransactionEntitySwapHistory {
  final DateTime dateTime;
  final SwapTxConfirmationState confirmationState;
  final double? amount;

  const TransactionEntitySwapHistory({
    required this.dateTime,
    required this.confirmationState,
    this.amount,
  });

  String get formattedDate => DateFormat("yyyy-MM-dd").format(dateTime);

  String get formattedDatePrecise =>
      DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
}

enum SwapTxConfirmationState {
  notsubmitted,
  submitted,
  settled,
  networkerror,
  expired,
  inital,
  review,
}
