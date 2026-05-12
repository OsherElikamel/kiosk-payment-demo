import 'dart:math';

import '../logger.dart';

class PaymentMethod {
  final String id;
  final String displayName;
  final Duration processingDelay;
  final String successMessage;
  final String failureMessage;
  final double successProbability;

  const PaymentMethod({
    required this.id,
    required this.displayName,
    required this.processingDelay,
    required this.successMessage,
    required this.failureMessage,
    required this.successProbability,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      processingDelay: Duration(milliseconds: json['processingDelay'] as int),
      successMessage: json['successMessage'] as String,
      failureMessage: json['failureMessage'] as String,
      successProbability: (json['successProbability'] as num).toDouble(),
    );
  }

  Future<PaymentResult> pay(
    double amount,
    String currency,
    String storeId,
    String storeName,
  ) async {
    await Future.delayed(processingDelay);

    final paymentId = 'PMT-${DateTime.now().millisecondsSinceEpoch}';
    final success = Random().nextDouble() < successProbability;

    await Logger.payment(
      paymentId: paymentId,
      methodId: id,
      amount: amount,
      currency: currency,
      storeId: storeId,
      storeName: storeName,
      success: success,
      message: success ? successMessage : failureMessage,
    );

    return PaymentResult(
      success: success,
      message: success ? successMessage : failureMessage,
    );
  }

  Future<void> cancel(
    String storeId,
    String storeName,
    String currency,
  ) async {
    final paymentId = 'PMT-${DateTime.now().millisecondsSinceEpoch}';

    await Logger.payment(
      paymentId: paymentId,
      methodId: id,
      amount: 0,
      currency: currency,
      storeId: storeId,
      storeName: storeName,
      success: false,
      message: 'Payment cancelled by user',
    );

    await Future.delayed(const Duration(milliseconds: 300));
  }
}

class PaymentResult {
  final bool success;
  final String message;

  const PaymentResult({required this.success, required this.message});
}
