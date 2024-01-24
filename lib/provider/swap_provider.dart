import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/utils.dart/js_communication.dart';
import 'package:swapping_webon/provider/swap_asstes_provider.dart';
import 'package:swapping_webon/provider/model/swap_order.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/provider/model/swapping_sevice.dart';
import 'package:swapping_webon/utils.dart/amount.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

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

  // Executes the Swap.

  Future<String?> swap() async {
    state = AsyncLoading();
    final info = ref.read(swapInfoProvider);

    try {
      var (api, order!) = ref.read(swapSchedulerProvider);
      var prefix = api?.name;

      // Transaction gets send out
      final depositAddress = order.depositAddress;

      final depositAmount = switch (order) {
        FixedSwapOrder order => order.depositAmount,
        VarSwapOrder _ => info.fromAmount.displayValue,
      };

      if (order is VarSwapOrder) {
        if (order.maxDepositAmount < depositAmount) {
          throw Exception("Amount too high");
        }
        if (order.minDepositAmount > depositAmount) {
          throw Exception("Amount too low");
        }
      }

      final before = getDecimals(depositAmount);

      final bi = depositAmount.toString().replaceAll('.', '').padRight(
            before + info.from.decimals,
            '0',
          );

      Token depositToken = info.from;

      final depositAmountEntity = Amount(
        value: BigInt.parse(bi),
        decimals: depositToken.decimals,
      );

      // final network = deposit_token.network;
      // if (network == null) throw Exception("Network not found");

      final transaction = await WalletBridge.sendAssets(
        sendAssetsArguments: NomoSendAssetsArguments(
          targetAddress: depositAddress,
          amount: depositAmountEntity.value.toString(),
          asset: AssetArguments(
            symbol: depositToken.symbol,
          ),
        ),
      );

      print("Transaction: $transaction");

      String transactionHash = "hash";

      state = AsyncValue.data(SwapState.swap);

      ref.invalidate(swapSchedulerProvider);

      return transactionHash;
    } on Exception catch (e, s) {
      print("This is the error in swap: $e");
      state = AsyncValue.error(e, s);
      return null;
    } catch (error) {
      print(error);
      state = AsyncValue.error(
        error,
        StackTrace.fromString("Swap Error"),
      );
      return null;
    }
  }

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

      print("Quote!: $quote");

      // Create Fixed Shift
      final order = await SwappingService.postFixedOrder(
        api.shift,
        quote.id,
        to: info.to,
        from: info.from,
      );

      print("Order: $order");

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
