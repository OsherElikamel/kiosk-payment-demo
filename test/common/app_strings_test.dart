import 'package:flutter_test/flutter_test.dart';
import 'package:kiosk_payment_demo/common/app_strings.dart';

void main() {
  tearDown(() => AppStrings.language = AppLanguage.english);

  test('defaults to English', () {
    expect(AppStrings.welcome, 'Welcome!');
    expect(AppStrings.cancel, 'Cancel');
  });

  test('switching to Hebrew swaps every string', () {
    AppStrings.language = AppLanguage.hebrew;

    expect(AppStrings.welcome, 'ברוך הבא!');
    expect(AppStrings.cancel, 'ביטול');
    expect(AppStrings.paymentSuccessful, 'תשלום בוצע בהצלחה!');
  });

  test('templates interpolate values in both languages', () {
    expect(AppStrings.itemsFoundInBags(3), '3 items found in the bags');
    expect(AppStrings.title('Shop'), 'PayTag Kiosk – Shop');
    expect(AppStrings.processingPaymentTemplate('Cash'), 'Paying with Cash');

    AppStrings.language = AppLanguage.hebrew;
    expect(AppStrings.itemsFoundInBags(3), contains('3'));
  });

  test('choosePaymentMethod reflects the selection state', () {
    expect(AppStrings.choosePaymentMethod(null), contains('Choose'));
    expect(AppStrings.choosePaymentMethod('Cash'), 'You chose Cash');
  });
}
