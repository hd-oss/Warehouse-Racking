import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/grid_section.dart';
import '../widgets/side_panel.dart';

class WarehousePage extends ConsumerWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;
              final container = isMobile
                  ? const Column(children: [
                      GridSection(isMobile: true),
                      SizedBox(height: 20),
                      Expanded(flex: 3, child: SidePanel()),
                    ])
                  : const Row(children: [
                      Expanded(flex: 2, child: GridSection(isMobile: false)),
                      SizedBox(width: 20),
                      Expanded(flex: 1, child: SidePanel()),
                    ]);

              return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ]),
                  child: container);
            },
          ),
        ),
      ),
    );
  }
}
