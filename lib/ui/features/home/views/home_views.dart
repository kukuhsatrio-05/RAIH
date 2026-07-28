import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raih/ui/features/home/providers/event_provider.dart';
import 'package:raih/ui/widgets/event_card.dart';

class HomeViews extends ConsumerStatefulWidget {
  const HomeViews({super.key});

  @override
  ConsumerState<HomeViews> createState() => _HomeViewsState();
}

class _HomeViewsState extends ConsumerState<HomeViews> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventProvider);
    final vm = ref.read(eventProvider.notifier);
    final events = state.filteredEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---- Header ----
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Temukan peluangmu',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF9094A6),
                            ),
                          ),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                              children: [
                                TextSpan(text: 'Info Lomba & '),
                                TextSpan(
                                  text: 'Beasiswa',
                                  style: TextStyle(color: Color(0xFF4A5CFC)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _FilterButton(
                      selectedSub: state.filterSubCategory,
                      onSelected: vm.setSubCategory,
                    ),
                  ],
                ),
              ),
            ),

            // ---- Search bar ----
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: TextField(
                  controller: _search,
                  onChanged: vm.setSearch,
                  decoration: InputDecoration(
                    hintText: 'Cari lomba & beasiswa',
                    hintStyle: const TextStyle(
                        fontSize: 13, color: Color(0xFFB0B3C6)),
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xFFB0B3C6), size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Color(0xFFE8E9F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Color(0xFF4A5CFC)),
                    ),
                  ),
                ),
              ),
            ),

            // ---- Filter chips ----
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(
                  children: ['Semua', 'Lomba', 'Beasiswa'].map((type) {
                    final active = state.filterType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => vm.setFilterType(type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: active
                                ? const Color(0xFF4A5CFC)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: active
                                  ? const Color(0xFF4A5CFC)
                                  : const Color(0xFFE8E9F0),
                            ),
                          ),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : const Color(0xFF9094A6),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ---- Grid ----
            events.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('Tidak ada hasil.')),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => EventCard(
                          event: events[i],
                          onTap: () => context.go('/detail/${events[i].id}'),
                        ),
                        childCount: events.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dropdown filter button
// ---------------------------------------------------------------------------
class _FilterButton extends StatelessWidget {
  final String selectedSub;
  final void Function(String) onSelected;

  const _FilterButton({required this.selectedSub, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF0FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.tune_rounded,
            color: Color(0xFF4A5CFC), size: 20),
      ),
      onSelected: onSelected,
      itemBuilder: (_) => eventSubCategories
          .map(
            (sub) => PopupMenuItem<String>(
              value: sub,
              child: Row(
                children: [
                  Icon(
                    sub == selectedSub
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    size: 16,
                    color: sub == selectedSub
                        ? const Color(0xFF4A5CFC)
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sub,
                    style: TextStyle(
                      fontWeight: sub == selectedSub
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: sub == selectedSub
                          ? const Color(0xFF1A1A2E)
                          : const Color(0xFF6B6F82),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
