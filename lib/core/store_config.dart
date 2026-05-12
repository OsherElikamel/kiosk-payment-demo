import 'dart:convert';

import 'package:flutter/services.dart';

import '../common/app_assets.dart';
import '../common/app_strings.dart';
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

  static Future<List<StoreConfig>> loadStores() async {
    final jsonString = await rootBundle.loadString(AppAssets.storesPath);
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => StoreConfig.fromJson(json)).toList();
  }

  static Future<StoreConfig> load() async {
    await Future.delayed(const Duration(milliseconds: 50));

    return StoreConfig(
      storeId: 'STORE_001',
      storeName: 'Paytag Store',
      currency: '₪',
      logoPath: AppAssets.logoPath,
      paymentMethods: [
        PaymentMethod(
          id: 'credit_card',
          displayName: AppStrings.paymentMethodCreditCard,
          processingDelay: const Duration(milliseconds: 600),
          successMessage: AppStrings.cardAuthorized,
          failureMessage: AppStrings.paymentCancelled,
          successProbability: 0.50,
        ),
        PaymentMethod(
          id: 'cash',
          displayName: AppStrings.paymentMethodCash,
          processingDelay: const Duration(milliseconds: 400),
          successMessage: AppStrings.cashAccepted,
          failureMessage: AppStrings.sendBackAmount,
          successProbability: 0.50,
        ),
        PaymentMethod(
          id: 'buyme',
          displayName: AppStrings.paymentMethodBuyMe,
          processingDelay: const Duration(milliseconds: 600),
          successMessage: AppStrings.buyMeSuccess,
          failureMessage: AppStrings.paymentCancelled,
          successProbability: 0.50,
        ),
        PaymentMethod(
          id: 'beastdaa',
          displayName: AppStrings.paymentMethodBeastdaa,
          processingDelay: const Duration(milliseconds: 600),
          successMessage: AppStrings.beastdaaSuccess,
          failureMessage: AppStrings.paymentCancelled,
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
      storeId: json['storeId'],
      storeName: json['storeName'],
      currency: json['currency'],
      logoPath: json['logoPath'] ?? AppAssets.logoPath,
      enabledPaymentMethods: List<String>.from(json['enabledPaymentMethods'] ?? []),
      paymentMethods: (json['paymentMethods'] as List)
          .map((pmJson) => PaymentMethod.fromJson(pmJson))
          .toList(),
    );
  }
}
