import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/core/store_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StoreConfig.fromJson', () {
    test('parses a full entry', () {
      final store = StoreConfig.fromJson(const {
        'storeId': 'S1',
        'storeName': 'Shop',
        'currency': '€',
        'logoPath': 'assets/images/apple_logo.png',
        'enabledPaymentMethods': ['cash'],
        'paymentMethods': [
          {
            'id': 'cash',
            'displayName': 'Cash',
            'processingDelay': 300,
            'successMessage': 'ok',
            'failureMessage': 'no',
            'successProbability': 0.8,
          },
        ],
      });

      expect(store.storeId, 'S1');
      expect(store.currency, '€');
      expect(store.paymentMethods, hasLength(1));
      expect(store.enabledPaymentMethods, ['cash']);
    });

    test('missing fields fall back to defaults instead of throwing', () {
      final store = StoreConfig.fromJson(const {});

      expect(store.storeId, '');
      expect(store.paymentMethods, isEmpty);
      expect(store.enabledPaymentMethods, isEmpty);
    });
  });

  group('StoreConfig.loadStores (bundled stores.json)', () {
    test('loads every store with its payment methods', () async {
      final stores = await StoreConfig.loadStores();

      expect(stores, hasLength(3));
      expect(
        stores.map((s) => s.storeId),
        ['STORE_001', 'STORE_002', 'STORE_003'],
      );

      final samsung = stores[1];
      expect(samsung.storeName, 'Samsung Store');
      expect(samsung.paymentMethods.map((m) => m.id), contains('paypal'));

      for (final store in stores) {
        expect(store.currency, isNotEmpty);
        expect(store.paymentMethods, isNotEmpty);
      }
    });
  });

  test('built-in fallback store has methods for every enabled id', () async {
    final store = await StoreConfig.load();

    final methodIds = store.paymentMethods.map((m) => m.id).toSet();
    for (final enabledId in store.enabledPaymentMethods) {
      expect(methodIds, contains(enabledId));
    }
  });
}
