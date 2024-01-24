import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/provider/history_model_service.dart';
import 'package:swapping_webon/provider/model/history_model.dart';
import 'package:swapping_webon/provider/permission_provider.dart';

const Duration duration = Duration(minutes: 1);

final historyUpdateProvider = StreamProvider<void>((ref) {
  return Stream.periodic(duration);
});

final historyProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<HistoryModel>>>(
        (ref) {
  ref.watch(historyUpdateProvider);
  return HistoryNotifier();
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<HistoryModel>>> {
  HistoryNotifier() : super(AsyncValue.loading()) {
    fetchData();
  }
  List<HistoryModel> list = [];

  Future<void> fetchData() async {
    try {
      state = const AsyncValue.loading();

      list = [
        for (final api in SwappingApi.values)
          ...await HistoryModelService.getHistory(api.history, api.name)
      ];

      list.sort((a, b) => -1 * a.createdAt.compareTo(b.createdAt));

      state = AsyncValue.data(list);
    } on SocketException {
      if (mounted) {
        state = AsyncValue.error(
          Exception("Could not establish a connection to the server."),
          StackTrace.current,
        );
      }
    } catch (e) {
      if (mounted) {
        state = AsyncValue.error(
          e is Exception ? e : Exception(e.toString()),
          StackTrace.current,
        );
      }
    }
  }

  // void filter(String text) {
  //   state = AsyncValue(
  //     list.where(
  //       (h) {
  //         final s = h.from.symbol + h.from.name + h.to.symbol + h.to.name;
  //         return s.toUpperCase().contains(
  //               text.toUpperCase(),
  //             );
  //       },
  //     ).toList(),
  //   );
  // }
}
