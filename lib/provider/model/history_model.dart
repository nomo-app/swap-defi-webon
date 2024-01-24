import 'package:swapping_webon/provider/model/swap_history.dart';
import 'package:swapping_webon/provider/model/tx_history_entity.dart';

class HistoryModel extends HistoryEntity {
  final String id;
  final String createdAt;
  final String depositCoin;
  final String settleCoin;
  final String depositNetwork;
  final String settleNetwork;
  final String depositAddress;
  final String settleAddress;
  final String depositMin;
  final String depositMax;
  final String type;

  final String? depositAmount;
  final String? settleAmount;
  final String expiresAt;
  final String status;
  final String? rate;
  final String? depositHash;
  final String prefix;

  HistoryModel({
    required this.id,
    required this.createdAt,
    required this.depositCoin,
    required this.settleCoin,
    required this.depositNetwork,
    required this.settleNetwork,
    required this.depositAddress,
    required this.settleAddress,
    required this.depositMin,
    required this.depositMax,
    required this.type,
    required this.depositAmount,
    required this.expiresAt,
    required this.status,
    required this.prefix,
    this.settleAmount,
    this.rate,
    this.depositHash,
  }) : super(
          fromSymbol: depositCoin == "ZENIQ" ? "ZENIQ @ETH" : depositCoin,
          toSymbol: settleCoin == "ZENIQ" ? "ZENIQ @ETH" : settleCoin,
          transaction: TransactionEntitySwapHistory(
            dateTime: DateTime.parse(createdAt),
            confirmationState: getState(status),
            amount: depositAmount == null ? null : double.parse(depositAmount),
          ),
        );

  static HistoryModel? fromJson(
    Map<String, dynamic> json,
    // String hash,
    String prefix,
  ) {
    if (json
        case {
          "id": String id,
          "createdAt": String createdAt,
          "depositCoin": String depositCoin,
          "settleCoin": String settleCoin,
          "depositNetwork": String depositNetwork,
          "settleNetwork": String settleNetwork,
          "depositAddress": String depositAddress,
          "settleAddress": String settleAddress,
          "depositMin": String depositMin,
          "depositMax": String depositMax,
          "type": String type,

          //"settleAmount": String settleAmount,
          "expiresAt": String expiresAt,
          "status": String status,
          // "rate": String rate,
          //  "depositHash": String depositHash,
        }) {
      final String depositAmount = json["depositAmount"] ?? "-";
      return HistoryModel(
        id: id,
        createdAt: createdAt,
        depositCoin: depositCoin,
        settleCoin: settleCoin,
        depositNetwork: depositNetwork,
        settleNetwork: settleNetwork,
        depositAddress: depositAddress,
        settleAddress: settleAddress,
        depositMin: depositMin,
        depositMax: depositMax,
        type: type,
        depositAmount: depositAmount,
        expiresAt: expiresAt,
        status: status,
        prefix: prefix,
      );
    }

    if (json
        case {
          "id": String id,
          "createdAt": String createdAt,
          "depositCoin": String depositCoin,
          "settleCoin": String settleCoin,
          "depositNetwork": String depositNetwork,
          "settleNetwork": String settleNetwork,
          "depositAddress": String depositAddress,
          "settleAddress": String settleAddress,
          "depositMin": String depositMin,
          "depositMax": String depositMax,
          //"refundAddress": String refundAddress,
          "type": String type,
          "depositAmount": String depositAmount,
          //"updatedAt": String updatedAt,
          //"depositReceivedAt": String depositReceivedAt,
          "expiresAt": String expiresAt,
          "status": String status,
          "rate": String rate,
          //"issue": String issue,
        }) {
      return HistoryModel(
        id: id,
        createdAt: createdAt,
        depositCoin: depositCoin,
        settleCoin: settleCoin,
        depositNetwork: depositNetwork,
        settleNetwork: settleNetwork,
        depositAddress: depositAddress,
        settleAddress: settleAddress,
        depositMin: depositMin,
        depositMax: depositMax,
        type: type,
        depositAmount: depositAmount,
        expiresAt: expiresAt,
        status: status,
        rate: rate,
        prefix: prefix,
      );
    }

    return null;
    // throw Exception("Invalid history model");
  }

  @override
  String toString() {
    return 'HistoryModel(id: $id, createdAt: $createdAt, depositCoin: $depositCoin, settleCoin: $settleCoin, depositNetwork: $depositNetwork, settleNetwork: $settleNetwork, depositAddress: $depositAddress, settleAddress: $settleAddress, depositMin: $depositMin, depositMax: $depositMax, type: $type, depositAmount: $depositAmount, expiresAt: $expiresAt, status: $status, rate: $rate, depositHash: $depositHash, prefix: $prefix)';
  }
}

SwapTxConfirmationState getState(String status) {
  switch (status) {
    case "waiting":
    case "pending":
    case "processing":
    case "settling":
      return SwapTxConfirmationState.submitted;
    case "review":
      return SwapTxConfirmationState.review;
    case "settled":
      return SwapTxConfirmationState.settled;
    default:
      return SwapTxConfirmationState.expired;
  }
}
