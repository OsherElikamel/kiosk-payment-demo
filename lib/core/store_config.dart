import 'dart:convert';

import 'package:flutter/services.dart';

import '../common/app_assets.dart';
import '../services/logger.dart';
import '../services/payments/payment_method.dart';

class StoreConfig {
  final String storeId;
  final String currency;
  final String storeName;
  final String logoPath;
  final List<PaymentMethod> paymentMethods;
  final List<String> enabledPaymentMethods;

  const StoreConfig({
    required this.storeId,
    required this.currency,
    required this.storeName,
    required this.logoPath,
    required this.paymentMethods,
    this.enabledPaymentMethods = const [],
  });

  /// Loads stores from the bundled JSON. A malformed entry is skipped and
  /// logged rather than discarding the whole file; throws only when no
  /// valid store remains (main.dart then falls back to the built-in store).
  static Future<List<StoreConfig>> loadStores() async {
    final jsonString = await rootBundle.loadString(AppAssets.storesPath);
    final List<dynamic> jsonList = json.decode(jsonString);

    final stores = <StoreConfig>[];
    for (final entry in jsonList) {
      try {
        stores.add(StoreConfig.fromJson(entry as Map<String, dynamic>));
      } catch (e, stack) {
        await Logger.e('Skipping malformed store entry: $e', stack);
      }
    }

    if (stores.isEmpty) {
      throw const FormatException('stores.json contains no valid stores');
    }
    return stores;
  }

  /// Built-in fallback used only when stores.json is unreadable. Both
  /// language variants are literals: resolving AppStrings here would
  /// freeze whichever language was active at construction time.
  static Future<StoreConfig> load() async {
    await Future.delayed(const Duration(milliseconds: 50));

    return const StoreConfig(
      storeId: 'STORE_001',
      storeName: 'Paytag Store',
      currency: '₪',
      logoPath: AppAssets.logoPath,
      paymentMethods: [
        PaymentMethod(
          id: 'credit_card',
          displayName: 'Credit Card',
          displayNameHe: 'כרטיס אשראי',
          processingDelay: Duration(milliseconds: 600),
          successMessage: 'Card authorized',
          successMessageHe: 'הכרטיס אושר',
          failureMessage: 'Payment cancelled',
          failureMessageHe: 'התשלום בוטל',
          successProbability: 0.50,
        ),
        PaymentMethod(
          id: 'cash',
          displayName: 'Cash',
          displayNameHe: 'מזומן',
          processingDelay: Duration(milliseconds: 400),
          successMessage: 'Cash accepted',
          successMessageHe: 'המזומן התקבל',
          failureMessage: 'Send back amount',
          failureMessageHe: 'החזר את הסכום שהוכנס',
          successProbability: 0.50,
        ),
        PaymentMethod(
          id: 'buyme',
          displayName: 'BuyMe',
          displayNameHe: 'ביי מי',
          processingDelay: Duration(milliseconds: 600),
          successMessage: 'BuyMe success',
          successMessageHe: 'ביי מי אושר',
          failureMessage: 'Payment cancelled',
          failureMessageHe: 'התשלום בוטל',
          successProbability: 0.50,
        ),
        PaymentMethod(
          id: 'beastdaa',
          displayName: 'Beastdaa',
          displayNameHe: 'ביסטדא',
          processingDelay: Duration(milliseconds: 600),
          successMessage: 'Beastdaa success',
          successMessageHe: 'ביסטדא אושר',
          failureMessage: 'Payment cancelled',
          failureMessageHe: 'התשלום בוטל',
          successProbability: 0.50,
        ),
      ],
      enabledPaymentMethods: [
        'credit_card',
        'cash',
        'buyme',
        'beastdaa',
      ],
    );
  }

  static StoreConfig fromJson(Map<String, dynamic> json) {
    return StoreConfig(
      storeId: json['storeId'] as String? ?? '',
      storeName: json['storeName'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      logoPath: json['logoPath'] as String? ?? AppAssets.logoPath,
      enabledPaymentMethods:
          List<String>.from(json['enabledPaymentMethods'] ?? []),
      paymentMethods: (json['paymentMethods'] as List? ?? [])
          .map((pmJson) => PaymentMethod.fromJson(pmJson))
          .toList(),
    );
  }
}
