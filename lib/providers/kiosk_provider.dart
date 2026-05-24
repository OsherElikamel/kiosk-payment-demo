import 'package:flutter/material.dart';
import '../common/app_strings.dart';
import '../core/store_config.dart';
import '../models/tag_item.dart';
import '../services/local_backend.dart';
import '../services/payments/payment_method.dart';

class KioskProvider extends ChangeNotifier {
  final LocalBackend backend = LocalBackend();
  final StoreConfig storeConfig;

  List<TagItem> scanned = [];
  PaymentMethod? selectedPayment;
  bool scanning = false;

  late final Map<String, PaymentMethod> _methods;
  late final List<String> _enabledIds;

  KioskProvider(this.storeConfig) {
    _methods = {
      for (final m in storeConfig.paymentMethods) m.id: m,
    };
    _enabledIds = storeConfig.enabledPaymentMethods.isEmpty
        ? _methods.keys.toList()
        : List.of(storeConfig.enabledPaymentMethods);
  }

  List<PaymentMethod> get availableMethods =>
      _methods.values
          .where((m) => _enabledIds.contains(m.id))
          .toList();

  String formatPrice(double price) =>
      '${storeConfig.currency} ${price.toStringAsFixed(2)}';

  double get total =>
      scanned.fold(0.0, (s, e) => s + e.price);

  Future<void> startScan() async {
    scanning = true;
    scanned = [];
    notifyListeners();

    scanned = await backend.scanOnce();
    scanning = false;
    notifyListeners();
  }

  void setPaymentMethod(String id) {
    selectedPayment = _methods[id];
    notifyListeners();
  }

  Future<PaymentResult> processPayment() async {
    if (selectedPayment == null) {
      return PaymentResult(
          success: false, message: AppStrings.noPaymentMethodSelected);
    }

    return await selectedPayment!.pay(total, storeConfig.currency, storeConfig.storeId, storeConfig.storeName);
  }

  void reset() {
    scanned = [];
    selectedPayment = null;
    scanning = false;
    notifyListeners();
  }
}
