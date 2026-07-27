import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/core/theme/app_colors.dart';
import 'package:raih/core/theme/app_text_styles.dart';
import 'package:raih/ui/features/counter_riverpod/providers/riverpod_counter_provider.dart';

class RiverpodCounterView extends ConsumerWidget {
  const RiverpodCounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(riverpodCounterProvider);
    final notifier = ref.read(riverpodCounterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Riverpod Counter",
          style: AppTextStyles.bold24.copyWith(color: AppColors.blueNormal),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Riverpod Counter Value:", style: AppTextStyles.regular16),
            const SizedBox(height: 16),
            Text(
              "$count",
              style: AppTextStyles.bold47.copyWith(color: AppColors.blueNormal),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: notifier.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: notifier.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
