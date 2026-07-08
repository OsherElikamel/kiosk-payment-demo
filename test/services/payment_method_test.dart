import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/services/payments/payment_method.dart';

PaymentMethod buildMethod({
  double probability = 1.0,
  Duration delay = const Duration(milliseconds: 10),
}) {
  return PaymentMethod(
    id: 'test_method',
    displayName: 'Test Method',
    processingDelay: delay,
    successMessage: 'approved',
    failureMessage: 'declined',
    successProbability: probability,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PaymentMethod.fromJson', () {
    test('parses a full entry', () {
      final method = PaymentMethod.fromJson(const {
        'id': 'credit_card',
        'displayName': 'Credit Card',
        'processingDelay': 700,
        'successMessage': 'Card approved',
        'failureMessage': 'Card declined',
        'successProbability': 0.6,
      });

      expect(method.id, 'credit_card');
      expect(method.displayName, 'Credit Card');
      expect(method.processingDelay, const Duration(milliseconds: 700));
      expect(method.successProbability, 0.6);
    });

    test('falls back to defaults on missing fields instead of throwing', () {
      final method = PaymentMethod.fromJson(const {});

      expect(method.id, '');
      expect(method.processingDelay, const Duration(milliseconds: 500));
      expect(method.successProbability, 0.5);
    });

    test('accepts an integer successProbability', () {
      final method = PaymentMethod.fromJson(const {'successProbability': 1});
      expect(method.successProbability, 1.0);
    });
  });

  group('PaymentMethod.pay', () {
    test('probability 1.0 always succeeds with the success message', () async {
      final result = await buildMethod(probability: 1.0)
          .pay(42.0, '₪', 'S1', 'Test Store');

      expect(result.success, isTrue);
      expect(result.cancelled, isFalse);
      expect(result.message, 'approved');
    });

    test('probability 0.0 always fails with the failure message', () async {
      final result = await buildMethod(probability: 0.0)
          .pay(42.0, '₪', 'S1', 'Test Store');

      expect(result.success, isFalse);
      expect(result.cancelled, isFalse);
      expect(result.message, 'declined');
    });

    test('a cancelled attempt never completes as a success', () async {
      final result = await buildMethod(probability: 1.0).pay(
        42.0,
        '₪',
        'S1',
        'Test Store',
        isCancelled: () => true,
      );

      expect(result.success, isFalse);
      expect(result.cancelled, isTrue);
    });
  });
}
