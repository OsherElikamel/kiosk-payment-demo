import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/services/local_backend.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalBackend.scanOnce (bundled Excel fixtures)', () {
    test('returns items from a real tag input file', () async {
      final items = await LocalBackend().scanOnce();

      expect(items, isNotEmpty);
      for (final item in items) {
        expect(item.tagId, isNotEmpty);
        expect(item.name, isNotEmpty);
        expect(item.price, greaterThanOrEqualTo(0));
        expect(item.assetPath, isNotEmpty);
      }
    });

    test('repeated scans keep working (cached availability probe)', () async {
      final backend = LocalBackend();

      final first = await backend.scanOnce();
      final second = await backend.scanOnce();

      expect(first, isNotEmpty);
      expect(second, isNotEmpty);
    });
  });
}
