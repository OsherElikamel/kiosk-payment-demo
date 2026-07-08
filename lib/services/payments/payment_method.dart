import 'dart:math';

import '../../common/app_strings.dart';
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
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      processingDelay: Duration(
          milliseconds: (json['processingDelay'] as num?)?.toInt() ?? 500),
      successMessage: json['successMessage'] as String? ?? '',
      failureMessage: json['failureMessage'] as String? ?? '',
      successProbability:
          (json['successProbability'] as num?)?.toDouble() ?? 0.5,
    );
  }

  /// Simulates a payment attempt. If [isCancelled] reports true once the
  /// processing delay elapses, the attempt is aborted and logged as
  /// CANCELLED instead of completing behind the user's back.
  Future<PaymentResult> pay(
    double amount,
    String currency,
    String storeId,
    String storeName, {
    bool Function()? isCancelled,
  }) async {
    await Future.delayed(processingDelay);

    final paymentId = 'PMT-${DateTime.now().millisecondsSinceEpoch}';

    if (isCancelled?.call() ?? false) {
      await Logger.payment(
        paymentId: paymentId,
        methodId: id,
        amount: amount,
        currency: currency,
        storeId: storeId,
        storeName: storeName,
        success: false,
        cancelled: true,
        message: 'Payment cancelled by user',
      );
      return PaymentResult(
        success: false,
        message: AppStrings.paymentCancelled,
        cancelled: true,
      );
    }

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
}

class PaymentResult {
  final bool success;
  final String message;
  final bool cancelled;

  const PaymentResult({
    required this.success,
    required this.message,
    this.cancelled = false,
  });
}
