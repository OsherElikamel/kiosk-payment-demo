import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kiosk_payment_demo/common/app_strings.dart';
import 'package:kiosk_payment_demo/core/store_config.dart';
import 'package:kiosk_payment_demo/providers/kiosk_provider.dart';
import 'package:kiosk_payment_demo/screens/welcome_screen.dart';
import 'package:kiosk_payment_demo/widgets/big_button.dart';

void main() {
  Widget buildApp() {
    const config = StoreConfig(
      storeId: 'TEST',
      storeName: 'Test Store',
      currency: '₪',
      logoPath: 'assets/images/paytag_logo.png',
      paymentMethods: [],
    );
    return ChangeNotifierProvider(
      create: (_) => KioskProvider(config),
      child: const MaterialApp(home: WelcomeScreen()),
    );
  }

  testWidgets('renders the welcome copy and a start button', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text(AppStrings.welcome), findsOneWidget);
    expect(find.text(AppStrings.insertItemsPrompt), findsOneWidget);
    expect(
        find.widgetWithText(BigButton, AppStrings.startLabel), findsOneWidget);
  });

  testWidgets('does not open developer mode before 7 logo taps',
      (tester) async {
    await tester.pumpWidget(buildApp());

    // The logo image never decodes inside a widget test, so its hit box
    // can be zero-sized depending on the Flutter build — invoke the tap
    // handler directly; the counter logic is what's under test.
    final detector =
        tester.widget<GestureDetector>(find.byKey(const Key('storeLogo')));

    for (var i = 0; i < 6; i++) {
      detector.onTap!();
      await tester.pump();
    }

    expect(find.text(AppStrings.devMode), findsNothing);

    detector.onTap!();
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.devMode), findsOneWidget);
  });
}
