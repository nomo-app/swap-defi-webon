import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/swap_asstes_provider.dart';
import 'package:swapping_webon/provider/swap_order.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/provider/swapping_sevice.dart';
import 'package:swapping_webon/widgets/amount.dart';
import 'package:swapping_webon/widgets/token.dart';

final swapProvider =
    StateNotifierProvider<SwapNotifier, AsyncValue<SwapState>>((ref) {
  return SwapNotifier(ref);
});

enum SwapState {
  quote,
  swap,
}

int getDecimals(double amount) {
  return amount.toString().split('.')[0].length;
}

class SwapNotifier extends StateNotifier<AsyncValue<SwapState>> {
  SwapNotifier(this.ref) : super(AsyncLoading());
  final Ref ref;

  ///
  /// Executes the Swap.
  ///
  // Future<SwapState> swap(BuildContext context) async {
  //   state = AsyncLoading();
  //   final info = ref.read(swapInfoProvider);

  //   try {
  //     var (api, order!) = ref.read(swapSchedulerProvider);
  //     var prefix = api?.name;

  //     // Transaction gets send out
  //     final deposit_address = order.depositAddress;

  //     final deposit_amount = switch (order) {
  //       FixedSwapOrder order => order.depositAmount,
  //       VarSwapOrder _ => info.fromAmount.displayValue,
  //     };

  //     if (order is VarSwapOrder) {
  //       if (order.maxDepositAmount < deposit_amount) {
  //         throw Exception("Amount too high");
  //       }
  //       if (order.minDepositAmount > deposit_amount) {
  //         throw Exception("Amount too low");
  //       }
  //     }

  //     final before = getDecimals(deposit_amount);

  //     final bi = deposit_amount.toString().replaceAll('.', '').padRight(
  //           before + info.from.decimals,
  //           '0',
  //         );

  //     Token deposit_token = info.from;

  //     final depositAmountEntity = Amount(
  //       value: BigInt.parse(bi),
  //       decimals: deposit_token.decimals,
  //     );

  //     final network = deposit_token.network;
  //     if (network == null) throw Exception("Network not found");

  //     // String hash = await network.send(
  //     //   intent: TransferIntent(
  //     //     amount: depositAmountEntity,
  //     //     recipient: deposit_address,
  //     //     token: deposit_token,
  //     //     feePriority: FeePriority.medium,
  //     //   ),
  //     // );

  //     // if (prefix != null) saveId(hash, order.id, prefix);

  //      state = AsyncValue.data(SwapState.swap);

  //      ref.invalidate(swapSchedulerProvider);

  //     return state as SwapState;

  //   } on ShiftFailure catch (e) {
  //     state = AsyncOperation.error(e);
  //     return state;
  //   } catch (error) {
  //     print(error);
  //     state = AsyncOperation.error(
  //       error is QuoteFailure
  //           ? Failure(error.message)
  //           : Failure(
  //               error.toString(), // translate('failure_unexpected'),
  //             ),
  //     );
  //     return state;
  //   }
  // }

  ///
  /// Gets Quote and overall Swap Info.
  ///
  Future<bool> getQuote() async {
    state = AsyncLoading();
    final info = ref.read(swapInfoProvider);

    try {
      final (api, _) = ref.read(swapSchedulerProvider);

      assert(api != null, "Swapping API is null!");

      // Get Quote
      final quote = await SwappingService.fetchQuote(
        api!.quote,
        info.from,
        info.to,
        info.fromAmount.value,
        null,
      );

      // Create Fixed Shift
      final order = await SwappingService.postFixedOrder(
        api.shift,
        quote.id,
        to: info.to,
        from: info.from,
      );

      ref.read(swapSchedulerProvider.notifier).updateSchedule(order);

      state = AsyncValue.data(SwapState.quote);
      return true;
    } on Exception catch (e, s) {
      print("This is the error in get Quote: $e");
      state = AsyncValue.error(e, s);
      return false;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return false;
    }
  }

  void saveId(String hash, String orderId, String prefix) {
    // try {
    //   final box = getGlobalHiveBox();
    //   var list = (box.get('$prefix/swap_history') ?? {}) as Map;
    //   list[hash] = orderId;
    //   box.put('$prefix/swap_history', list);
    // } catch (e) {
    //   print(e);
    // }
    print("Save ID: $hash, $orderId, $prefix");
  }
}

class SwapScheduleNotifier extends StateNotifier<SwapSchedule> {
  SwapScheduleNotifier() : super((null, null));

  void setSwappingApi(SwappingApi api) {
    state = (api, state.$2);
  }

  void updateSchedule(
    SwapOrder order,
  ) {
    state = (state.$1, order);
  }
}

final swapSchedulerProvider =
    StateNotifierProvider<SwapScheduleNotifier, SwapSchedule>((ref) {
  return SwapScheduleNotifier();
});

typedef SwapSchedule = (SwappingApi? api, SwapOrder? order);
