import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/swap_provider.dart';
import 'package:swapping_webon/provider/model/swapinfo.dart';
import 'package:swapping_webon/provider/swapinfo_provider.dart';
import 'package:swapping_webon/provider/model/swapping_sevice.dart';

const loadingPreview = AsyncValue.data(SwapPreview(-1));
const refetchPreview = AsyncValue.data(SwapPreview(-2));
const wrongInputPreview = AsyncValue.data(SwapPreview(-3));

const _previewRefreshInterval = Duration(seconds: 2);

class SwapPreview {
  final double amount;
  final double? rate;
  final double? gasPrice;

  const SwapPreview(
    this.amount, {
    this.rate,
    this.gasPrice,
  });

  @override
  String toString() => "amount: $amount; rate: $rate; gasPrice: $gasPrice";
}

class SwapPreviewNotifier extends StateNotifier<AsyncValue<SwapPreview>> {
  final Ref ref;

  SwapPreviewNotifier(this.ref) : super(loadingPreview) {
    Stream.periodic(_previewRefreshInterval).listen((event) {
      if (mounted) loadNewPreview();
    });
  }

  SwapInfo? last;
  SwapInfo? error;

  bool useFrom = true;

  bool get getIfFromIsUsed => useFrom;

  void setLoading(SwapInfo info) {
    if (info.fromToValid && info.amountValid) {
      last = null;
      error = null;
      state = refetchPreview;
    } else {
      state = loadingPreview;
    }
  }

  void switchEdit(bool isFrom) {
    if (isFrom) {
      useFrom = true;
    } else {
      useFrom = false;
    }
  }

  void loadNewPreview() async {
    final info = ref.read(swapInfoProvider);

    if (last?.isOther(info, useFrom) ?? false) {
      return;
    }

    if (error?.isOther(info, useFrom) ?? false) {
      return;
    }

    final isValid = info.isValid;

    final fromBalanceString = info.from.balance;
    final fromBalance = BigInt.tryParse(fromBalanceString ?? "0");

    if ((fromBalance ?? BigInt.from(0)) < info.fromAmount.value) {
      return;
    }

    if (isValid) {
      state = const AsyncValue.loading();
      print("Fetch Quote Preview");

      final fromAmount = useFrom ? info.fromAmount.value : null;
      final toAmount = useFrom ? null : info.toAmount.value;
      final from = info.from;
      final to = info.to;

      try {
        final (swappingApi!, _) = ref.read(swapSchedulerProvider);

        final quote = await SwappingService.fetchQuote(
          swappingApi.quote,
          from,
          to,
          fromAmount,
          toAmount,
        );

        print("this is the quote we got $quote");

        final amount = useFrom ? quote.settleAmount : quote.depositAmount;

        if (amount <= 0) {
          throw Exception("Amount too low");
        }
        if (state != loadingPreview) {
          state = AsyncValue.data(SwapPreview(amount, rate: quote.rate));
          last = info;
          error = null;
        }
      } catch (e, s) {
        if (e is Exception) {
          error = info;
        }

        state = AsyncValue.error(e, s);

        // if (state != loadingPreview) {
        //   state = AsyncValue.error(e, s);
        // }
      }
    } else {
      state = loadingPreview;
    }
  }
}

final swapPreviewProvider = StateNotifierProvider.autoDispose<
    SwapPreviewNotifier, AsyncValue<SwapPreview>>((ref) {
  return SwapPreviewNotifier(ref);
});
