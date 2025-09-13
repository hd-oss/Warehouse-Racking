import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/history_model.dart';

class HistoryRepository {
  Future<List<History>> fetchHistory() async {
    final query = QueryBuilder<ParseObject>(ParseObject('History'))
      ..orderByDescending('createdAt');

    final response = await query.query();

    if (response.success && response.results != null) {
      return (response.results ?? []).map((e) {
        final obj = e as ParseObject;
        return History(
            action: obj.get<String>('action') ?? '',
            row: obj.get<int>('row') ?? 0,
            col: obj.get<int>('col') ?? 0,
            timestamp: obj.get<DateTime>('timestamp') ?? DateTime.now());
      }).toList();
    }

    return [];
  }
}
