import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/history_model.dart';
import '../data/repositories/history_repository.dart';

final historyRepositoryProvider = Provider((ref) => HistoryRepository());

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<History>>((ref) {
  final repo = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repo);
});

class HistoryNotifier extends StateNotifier<List<History>> {
  final HistoryRepository repository;

  HistoryNotifier(this.repository) : super([]) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = await repository.fetchHistory();
  }

  // Future<void> add(String action, int row, int col) async {
  //   await repository.saveHistory(History(
  //     action: action,
  //     row: row,
  //     col: col,
  //     timestamp: DateTime.now(),
  //   ));
  //   await loadHistory(); // refresh list setelah insert
  // }
}
