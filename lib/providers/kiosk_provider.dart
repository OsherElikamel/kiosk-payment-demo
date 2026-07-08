import 'package:flutter/material.dart';
import '../common/app_strings.dart';
import '../core/store_config.dart';
import '../models/tag_item.dart';
import '../services/local_backend.dart';
import '../services/logger.dart';
import '../services/payments/payment_method.dart';

class KioskProvider extends ChangeNotifier {
  final LocalBackend backend = LocalBackend();
  final StoreConfig storeConfig;

  List<TagItem> scanned = [];
  PaymentMethod? selectedPayment;
  bool scanning = false;
  bool _cancelRequested = false;

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

    try {
      scanned = await backend.scanOnce();
    } catch (e, stack) {
      Logger.e('Scan failed: $e', stack);
    } finally {
      scanning = false;
      notifyListeners();
    }
  }

  void setPaymentMethod(String id) {
    selectedPayment = _methods[id];
    notifyListeners();
  }

  /// Marks the in-flight payment as cancelled; [processPayment] checks this
  /// before committing, so a cancelled attempt is logged as CANCELLED
  /// instead of completing behind the user's back.
  void requestPaymentCancel() {
    _cancelRequested = true;
  }

  Future<PaymentResult> processPayment() async {
    final method = selectedPayment;
    if (method == null) {
      return PaymentResult(
          success: false, message: AppStrings.noPaymentMethodSelected);
    }

    _cancelRequested = false;
    try {
      return await method.pay(
        total,
        storeConfig.currency,
        storeConfig.storeId,
        storeConfig.storeName,
        isCancelled: () => _cancelRequested,
      );
    } catch (e, stack) {
      Logger.e('Payment failed: $e', stack);
      return PaymentResult(
          success: false, message: AppStrings.paymentProcessingError);
    }
  }

  void reset() {
    scanned = [];
    selectedPayment = null;
    scanning = false;
    notifyListeners();
  }
}
