import 'package:shared_preferences/shared_preferences.dart';

class CarFundService {
  static const String _fundKey = 'car_fund_balance';

  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fundKey) ?? 0.0;
  }

  static Future<void> addToFund(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getBalance();
    await prefs.setDouble(_fundKey, current + amount);
  }
}
