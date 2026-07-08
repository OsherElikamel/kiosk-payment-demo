import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/app.dart';
import 'package:kiosk_payment_demo/common/app_strings.dart';
import 'package:kiosk_payment_demo/core/store_config.dart';
import 'package:kiosk_payment_demo/screens/welcome_screen.dart';

void main() {
  const config = StoreConfig(
    storeId: 'TEST',
    storeName: 'Test Store',
    currency: '₪',
    logoPath: 'assets/images/paytag_logo.png',
    paymentMethods: [],
  );

  tearDown(() => AppStrings.language = AppLanguage.english);

  testWidgets('renders LTR in English and RTL in Hebrew', (tester) async {
    await tester.pumpWidget(const PaytagApp(storeConfig: config));

    final welcome = tester.element(find.byType(WelcomeScreen));
    expect(Directionality.of(welcome), TextDirection.ltr);

    AppStrings.language = AppLanguage.hebrew;
    await tester.pumpAndSettle();

    final welcomeRtl = tester.element(find.byType(WelcomeScreen));
    expect(Directionality.of(welcomeRtl), TextDirection.rtl);
    expect(find.text('ברוך הבא!'), findsOneWidget);
  });
}
