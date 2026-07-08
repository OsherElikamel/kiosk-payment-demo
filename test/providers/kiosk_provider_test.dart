import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/common/app_strings.dart';
import 'package:kiosk_payment_demo/core/store_config.dart';
import 'package:kiosk_payment_demo/models/tag_item.dart';
import 'package:kiosk_payment_demo/providers/kiosk_provider.dart';
import 'package:kiosk_payment_demo/services/payments/payment_method.dart';

PaymentMethod buildMethod(
  String id, {
  double probability = 1.0,
  Duration delay = const Duration(milliseconds: 10),
}) {
  return PaymentMethod(
    id: id,
    displayName: id.toUpperCase(),
    processingDelay: delay,
    successMessage: 'approved',
    failureMessage: 'declined',
    successProbability: probability,
  );
}

StoreConfig buildConfig({
  List<PaymentMethod>? methods,
  List<String> enabled = const [],
}) {
  return StoreConfig(
    storeId: 'TEST_STORE',
    storeName: 'Test Store',
    currency: '₪',
    logoPath: 'assets/images/paytag_logo.png',
    paymentMethods: methods ?? [buildMethod('card'), buildMethod('cash')],
    enabledPaymentMethods: enabled,
  );
}

const items = [
  TagItem(tagId: 'T1', assetPath: 'a', price: 10.5, name: 'One'),
  TagItem(tagId: 'T2', assetPath: 'b', price: 4.5, name: 'Two'),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('cart math', () {
    test('total sums scanned item prices', () {
      final p = KioskProvider(buildConfig())..scanned = List.of(items);
      expect(p.total, 15.0);
    });

    test('formatPrice uses the store currency with two decimals', () {
      final p = KioskProvider(buildConfig());
      expect(p.formatPrice(15.0), '₪ 15.00');
    });
  });

  group('payment methods', () {
    test('empty enabled list exposes all methods', () {
      final p = KioskProvider(buildConfig());
      expect(p.availableMethods.map((m) => m.id), ['card', 'cash']);
    });

    test('enabled list filters the available methods', () {
      final p = KioskProvider(buildConfig(enabled: ['cash']));
      expect(p.availableMethods.map((m) => m.id), ['cash']);
    });

    test('setPaymentMethod selects by id; unknown id selects nothing', () {
      final p = KioskProvider(buildConfig());

      p.setPaymentMethod('card');
      expect(p.selectedPayment?.id, 'card');

      p.setPaymentMethod('nonexistent');
      expect(p.selectedPayment, isNull);
    });
  });

  group('processPayment', () {
    test('without a selected method fails with the localized message',
        () async {
      final p = KioskProvider(buildConfig());

      final result = await p.processPayment();

      expect(result.success, isFalse);
      expect(result.message, AppStrings.noPaymentMethodSelected);
    });

    test('succeeds with a probability-1.0 method', () async {
      final p = KioskProvider(buildConfig())
        ..scanned = List.of(items)
        ..setPaymentMethod('card');

      final result = await p.processPayment();

      expect(result.success, isTrue);
    });

    test('requestPaymentCancel mid-flight aborts the attempt', () async {
      final p = KioskProvider(buildConfig(methods: [
        buildMethod('card', delay: const Duration(milliseconds: 100)),
      ]))
        ..scanned = List.of(items)
        ..setPaymentMethod('card');

      final pending = p.processPayment();
      p.requestPaymentCancel();
      final result = await pending;

      expect(result.cancelled, isTrue);
      expect(result.success, isFalse);
    });

    test('a new attempt after a cancelled one is not stuck cancelled',
        () async {
      final p = KioskProvider(buildConfig())
        ..scanned = List.of(items)
        ..setPaymentMethod('card');

      final pending = p.processPayment();
      p.requestPaymentCancel();
      await pending;

      final second = await p.processPayment();
      expect(second.cancelled, isFalse);
      expect(second.success, isTrue);
    });
  });

  test('reset clears cart, selection, and scanning state', () {
    final p = KioskProvider(buildConfig())
      ..scanned = List.of(items)
      ..setPaymentMethod('card')
      ..scanning = true;

    p.reset();

    expect(p.scanned, isEmpty);
    expect(p.selectedPayment, isNull);
    expect(p.scanning, isFalse);
  });
}
