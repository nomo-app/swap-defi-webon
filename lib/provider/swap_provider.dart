import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/swap_asstes_provider.dart';
import 'package:swapping_webon/provider/model/swap_order.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/provider/model/swapping_sevice.dart';
import 'package:swapping_webon/utils.dart/amount.dart';
import 'package:swapping_webon/widgets/swap_card.dart';
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

class FallBackAsset {
  final Amount amount;
  final String targetAddress;
  final String symbol;

  FallBackAsset(this.amount, this.targetAddress, this.symbol);
}

class SwapNotifier extends StateNotifier<AsyncValue<SwapState>> {
  SwapNotifier(this.ref) : super(const AsyncLoading());
  final Ref ref;

  // Executes the Swap.

  Future<dynamic> swap() async {
    state = const AsyncLoading();
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

      final tx = await WebonKitDart.sendAssets(
        targetAddress: depositAddress,
        amount: depositAmountEntity.value.toString(),
        symbol: depositToken.symbol,
      );

      ref.read(goToSendScreenProvider.notifier).state = false;
      print("This is the tx: $tx");

      String transactionHash = "hash";

      // if (prefix != null) saveId(order.id, prefix);

      state = const AsyncValue.data(SwapState.swap);

      ref.invalidate(swapSchedulerProvider);

      if (tx == "fallback") {
        final fallbackAsset = FallBackAsset(
          depositAmountEntity,
          depositAddress,
          depositToken.symbol,
        );

        return fallbackAsset;
      }
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
    state = const AsyncLoading();
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

      state = const AsyncValue.data(SwapState.quote);
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

  void saveId(String orderId, String prefix) async {
    int count = 0;

    while (true) {
      final result = await WebonKitDart.getLocalStorage(
        key: '$prefix/swap_history/$count',
      );

      if (result == null) {
        break;
      }
      count++;
    }

    await WebonKitDart.setLocalStorage(
      key: '$prefix/swap_history/$count',
      value: orderId,
    );

    print("Save ID: $prefix/swap_history/$count");
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
