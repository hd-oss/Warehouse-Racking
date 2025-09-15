import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/history_notifier.dart';
import '../../logic/input_notifier.dart';
import '../../logic/racking_notifier.dart';

class SidePanel extends ConsumerWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(inputProvider);
    final history = ref.watch(historyProvider);

    void showLoadingDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    void showErrorDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Terjadi Kesalahan"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    }

    Widget buildHistoryList() {
      if (history.isEmpty) {
        return const Center(child: Text('No history available'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: history.length,
        itemBuilder: (context, idx) => ListTile(
          dense: true,
          title: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: history[idx].action,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      history[idx].action == "IN" ? Colors.red : Colors.green,
                ),
              ),
              TextSpan(text: " (${history[idx].row}, ${history[idx].col})"),
            ]),
          ),
          subtitle: Text(
            history[idx].timestamp.toString().substring(0, 19),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min, // 🔑 penting untuk mobile
      children: [
        // Panel Input
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Panel Input",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Aksi",
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                value: input.action ?? "IN",
                items: const [
                  DropdownMenuItem(value: "IN", child: Text("IN")),
                  DropdownMenuItem(value: "OUT", child: Text("OUT")),
                ],
                onChanged: ref.read(inputProvider.notifier).updateAction,
              ),
              const SizedBox(height: 12),

              // Input Row dan Col
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Col",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        counterText: "",
                      ),
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: ref.read(inputProvider.notifier).updateCol,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Row",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        counterText: "",
                      ),
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: ref.read(inputProvider.notifier).updateRow,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final notifier = ref.read(rackingProvider.notifier);
                  final historyNotifier = ref.read(historyProvider.notifier);

                  if (input.action != null &&
                      input.row != null &&
                      input.col != null) {
                    try {
                      showLoadingDialog(context);

                      await notifier.setOccupied(
                        input.row!,
                        input.col!,
                        input.action == "IN",
                      );

                      await historyNotifier.loadHistory();

                      if (!context.mounted) return;
                      Navigator.of(context).pop(); // Tutup loading

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Update berhasil ✅")),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      Navigator.of(context).pop(); // Tutup loading
                      showErrorDialog(context, e.toString());
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Row, Col, dan Action harus diisi ⚠️"),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text("Submit"),
              )
            ],
          ),
        ),

        // Panel Riwayat
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: buildHistoryList(),
          ),
        ),
      ],
    );
  }
}
