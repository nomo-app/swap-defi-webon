import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/permission_provider.dart';
import 'package:swapping_webon/provider/swap_preview.dart';
import 'package:swapping_webon/provider/model/swapinfo.dart';
import 'package:swapping_webon/utils.dart/amount.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class SwapInfoNotifier extends StateNotifier<SwapInfo> {
  final Ref ref;

  SwapInfoNotifier(this.ref) : super(SwapInfo.zero());

  void setFrom(Token from) {
    // _loadBalanceIfNull(from);
    if (!state.fromIsNullToken) {
      state = state.copyWith(from: from, fromAmount: BigInt.zero);
      return;
    }
    state = state.copyWith(from: from);
  }

  void setTo(Token to) {
    //   _loadBalanceIfNull(to);
    if (!state.toIsNullToken) {
      state = state.copyWith(to: to, toAmount: BigInt.zero);
      return;
    }
    state = state.copyWith(to: to);
  }

  get fromToken => state.from;
  get toToken => state.to;

  void clearAll() => state = SwapInfo.zero();

  void setFromAmount(BigInt amount) => state = state.copyWith(
        fromAmount: amount,
      );

  void setToAmount(BigInt amount) => state = state.copyWith(toAmount: amount);

  void switchFromTo() => state = state.copyWith(
        from: state.to,
        to: state.from,
        fromAmount: state.toAmount.value,
        toAmount: state.fromAmount.value,
      );
}

final swapInfoProvider =
    StateNotifierProvider<SwapInfoNotifier, SwapInfo>((ref) {
  return SwapInfoNotifier(ref);
});

final balanceValidProvider = StateProvider.autoDispose<bool>((ref) {
  final token = ref.watch(swapInfoProvider.select((value) => value.from));

  final hasBalance = token.balance != null;
  var showError = false;
  if (hasBalance) {
    try {
      final balanceBI =
          Amount.fromString(value: token.balance!, decimals: token.decimals)
              .value;

      showError = balanceBI == BigInt.zero;
      return showError;
    } catch (e) {
      print("This is the error in swapInfoProvider!: $e");
    }
  }
  return false;
});

final amountValidFromProvider = StateProvider.autoDispose<bool>((ref) {
  final token = ref.watch(swapInfoProvider.select((value) => value.from));

  final hasBalance = token.balance != null;
  BigInt balance;
  bool valid = false;

  if (hasBalance) {
    try {
      balance =
          Amount.fromString(value: token.balance!, decimals: token.decimals)
              .value;
      final info = ref.watch(swapInfoProvider);
      valid = info.fromAmountIsValid(balance);
    } catch (e) {
      print("This is the error in swapinfo:  $e");
    }
  }

  return valid;
});

final canScheduleProvider = StateProvider.autoDispose<bool>((ref) {
  final permission = ref.watch(permissionProvider);
  final info = ref.watch(swapInfoProvider);
  final amountValid = ref.watch(amountValidFromProvider);
  final outputValid = ref.watch(swapPreviewProvider).when<bool>(
        data: (data) {
          return data.amount > 0;
        },
        error: (_, __) => false,
        loading: () => false,
      );

  return permission.when<bool>(
    data: (hasPermission) {
      return hasPermission && info.fromToValid && amountValid && outputValid;
    },
    error: (e, s) {
      return false;
    },
    loading: () {
      return false;
    },
  );
});
