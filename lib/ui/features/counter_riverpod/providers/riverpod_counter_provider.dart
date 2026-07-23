import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodCounter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}

final riverpodCounterProvider = NotifierProvider<RiverpodCounter, int>(() {
  return RiverpodCounter();
});
