import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final coinProvider = StateNotifierProvider<CoinNotifier, int>((ref) {
  return CoinNotifier();
});

class CoinNotifier extends StateNotifier<int> {
  CoinNotifier() : super(0) {
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('totalCoins') ?? 0;
  }

  Future<void> updateCoins(int newAmount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalCoins', newAmount);
    state = newAmount;
  }

  Future<void> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentCoins = prefs.getInt('totalCoins') ?? 0;
    final newAmount = currentCoins + amount;
    await prefs.setInt('totalCoins', newAmount);
    state = newAmount;
  }
}
