import 'dart:math';

import '../../common/app_strings.dart';
import '../logger.dart';

class PaymentMethod {
  final String id;
  final String displayName;
  final String? displayNameHe;
  final Duration processingDelay;
  final String successMessage;
  final String? successMessageHe;
  final String failureMessage;
  final String? failureMessageHe;
  final double successProbability;

  const PaymentMethod({
    required this.id,
    required this.displayName,
    this.displayNameHe,
    required this.processingDelay,
    required this.successMessage,
    this.successMessageHe,
    required this.failureMessage,
    this.failureMessageHe,
    required this.successProbability,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      displayNameHe: json['displayNameHe'] as String?,
      processingDelay: Duration(
          milliseconds: (json['processingDelay'] as num?)?.toInt() ?? 500),
      successMessage: json['successMessage'] as String? ?? '',
      successMessageHe: json['successMessageHe'] as String?,
      failureMessage: json['failureMessage'] as String? ?? '',
      failureMessageHe: json['failureMessageHe'] as String?,
      successProbability:
          (json['successProbability'] as num?)?.toDouble() ?? 0.5,
    );
  }

  /// Resolved at display time so a runtime language switch takes effect;
  /// falls back to the English value when no Hebrew variant is configured.
  String get localizedDisplayName => _localized(displayName, displayNameHe);
  String get localizedSuccessMessage =>
      _localized(successMessage, successMessageHe);
  String get localizedFailureMessage =>
      _localized(failureMessage, failureMessageHe);

  static String _localized(String en, String? he) =>
      AppStrings.language == AppLanguage.hebrew ? (he ?? en) : en;

  /// Simulates a payment attempt. If [isCancelled] reports true once the
  /// processing delay elapses, the attempt is aborted and logged as
  /// CANCELLED instead of completing behind the user's back.
  /// Log entries always use the English strings; the returned
  /// [PaymentResult] carries the localized message for the UI.
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
      message: success ? localizedSuccessMessage : localizedFailureMessage,
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
