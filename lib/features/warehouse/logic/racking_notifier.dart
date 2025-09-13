import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/racking_model.dart';
import '../data/repositories/warehouse_repository.dart';

final warehouseRepositoryProvider = Provider((ref) => WarehouseRepository());

final rackingProvider =
    StateNotifierProvider<RackingNotifier, List<Racking>>((ref) {
  final repo = ref.watch(warehouseRepositoryProvider);
  return RackingNotifier(repo);
});

class RackingNotifier extends StateNotifier<List<Racking>> {
  final WarehouseRepository repository;

  RackingNotifier(this.repository) : super([]) {
    loadRacking();
  }

  Future<void> loadRacking() async {
    state = await repository.fetchRacking();
  }

  Future<void> setOccupied(
    int row,
    int col,
    bool occupied,
  ) async {
    await repository.updateRack(row, col, occupied);
    state = [
      for (final rack in state)
        if (rack.row == row && rack.col == col)
          Racking(
            row: row,
            col: col,
            occupied: occupied,
          )
        else
          rack
    ];
  }
}
