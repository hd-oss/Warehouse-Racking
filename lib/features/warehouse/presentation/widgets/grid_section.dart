import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/racking_notifier.dart';

class GridSection extends ConsumerWidget {
  final bool isMobile;
  const GridSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final racking = ref.watch(rackingProvider);

    if (racking.isEmpty) {
      return const Center(child: Text('No racks available'));
    }

    final maxRow =
        racking.fold<int>(0, (prev, r) => r.row > prev ? r.row : prev);
    final maxCol =
        racking.fold<int>(0, (prev, r) => r.col > prev ? r.col : prev);

    // Buat map untuk akses cepat
    final rackMap = {
      for (var rack in racking) '${rack.row}-${rack.col}': rack,
    };

    Widget buildRacking() {
      return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: maxCol,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1.5),
          itemCount: maxRow * maxCol,
          itemBuilder: (context, index) {
            final row = maxRow - (index ~/ maxCol); // <-- membalik row
            final col = index % maxCol + 1;
            final rack = rackMap['$row-$col'];

            Color color;
            Border? border;
            if (rack == null || !rack.active) {
              color = Colors.grey[200]!;
            } else {
              color = rack.occupied ? Colors.red : Colors.green;
            }

            return Container(
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                  border: border),
            );
          });
    }

    return Column(
      children: [
        buildRacking(),
        const SizedBox(height: 12),
        Row(
          children: [
            _legendItem(Colors.green, "Available"),
            const SizedBox(width: 6),
            _legendItem(Colors.red, "Occupied"),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: isMobile ? 10 : 20,
          height: isMobile ? 10 : 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          )),
      const SizedBox(width: 6),
      Text(label),
    ]);
  }
}
