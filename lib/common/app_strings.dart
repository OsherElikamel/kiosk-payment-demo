import 'package:flutter/material.dart';

/// Supported languages
enum AppLanguage { english, hebrew }

/// Global app strings
class AppStrings {
  /// Global language notifier
  static final ValueNotifier<AppLanguage> currentLanguage =
      ValueNotifier<AppLanguage>(AppLanguage.english);

  /// Get current language
  static AppLanguage get language => currentLanguage.value;

  /// Set language
  static set language(AppLanguage lang) => currentLanguage.value = lang;

  /// Helper for replacing templates
  static String _replace(String template, Map<String, String> values) {
    var result = template;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  // Titles
  static String title(String storeName) {
    const en = 'PayTag Kiosk – {storeName}';
    const he = 'קיוסק פייטג – {storeName}';
    return _replace(language == AppLanguage.hebrew ? he : en, {'storeName': storeName});
  }

  static String productName(int productNumber) {
    const en = 'Product {productNumber}';
    const he = 'מוצר {productNumber}';
    return _replace(language == AppLanguage.hebrew ? he : en, {'productNumber': productNumber.toString()});
  }

  // General
  static String get unknownItem => language == AppLanguage.hebrew ? 'פריט לא ידוע' : 'Unknown Item';
  static String get startLabel => language == AppLanguage.hebrew ? 'התחל' : 'Start';
  static String get welcome => language == AppLanguage.hebrew ? 'ברוך הבא!' : 'Welcome!';
  static String get noItemsFound => language == AppLanguage.hebrew ? 'לא נמצאו פריטים' : 'No items found';
  static String get scanningInProcess => language == AppLanguage.hebrew ? 'סריקה בתהליך' : 'Scanning In Process';
  static String get cancel => language == AppLanguage.hebrew ? 'ביטול' : 'Cancel';
  static String get totalPrice => language == AppLanguage.hebrew ? 'מחיר כולל' : 'Total Price';
  static String get proceedToPayment => language == AppLanguage.hebrew ? 'להמשיך לתשלום' : 'Proceed to Payment';
  static String get paymentSuccessful => language == AppLanguage.hebrew ? 'תשלום בוצע בהצלחה!' : 'Payment Successful!';
  static String get paymentFailed => language == AppLanguage.hebrew ? 'התשלום נכשל' : 'Payment Failed';
  static String get continueLabel => language == AppLanguage.hebrew ? 'המשך' : 'Continue';
  static String get processingPayment => language == AppLanguage.hebrew ? 'מעבד את התשלום' : 'Processing Payment';

  static String choosePaymentMethod(String? method) {
    final en = method == null ? 'Choose Your\nPayment Method' : 'You chose $method';
    final he = method == null ? 'בחר את\nאמצעי התשלום שלך' : 'בחרת $method';
    return language == AppLanguage.hebrew ? he : en;
  }

  static String processingPaymentTemplate(String? method) {
    final en = method == null ? 'Processing Payment' : 'You chose $method';
    final he = method == null ? 'מעבדת תשלום' : 'בחרת $method';
    return language == AppLanguage.hebrew ? he : en;
  }

  static String itemsFoundInBags(int itemCount) {
    const en = '{itemCount} items found in the bags';
    const he = 'נמצאו {itemCount} פריטים בשקים';
    return _replace(language == AppLanguage.hebrew ? he : en, {'itemCount': itemCount.toString()});
  }

  static String get insertItemsPrompt =>
      language == AppLanguage.hebrew ? 'אנא הכנס את הפריטים ולחץ\nהתחל כדי לסרוק' : 'Please insert the items and press\nStart to scan';
  static String get demoFinished => language == AppLanguage.hebrew ? 'הדמו הסתיים' : 'Demo Finished';
  static String get restartLabel => language == AppLanguage.hebrew ? 'אתחל' : 'Restart';
  static String get selectPaymentMethodMessage =>
      language == AppLanguage.hebrew ? 'אנא בחר אמצעי תשלום לפני המשך' : 'Please select a payment method before continuing.';
  static String get noPaymentMethodSelected =>
      language == AppLanguage.hebrew ? 'לא נבחר אמצעי תשלום' : 'No payment method selected';

  // Payment methods
  static String get paymentMethodCreditCard => language == AppLanguage.hebrew ? 'כרטיס אשראי' : 'Credit Card';
  static String get paymentMethodCash => language == AppLanguage.hebrew ? 'מזומן' : 'Cash';
  static String get paymentMethodBuyMe => language == AppLanguage.hebrew ? 'ביי מי' : 'BuyMe';
  static String get paymentMethodBeastdaa => language == AppLanguage.hebrew ? 'ביסטדא' : 'Beastdaa';

  // Payment outcomes
  static String get cardAuthorized => language == AppLanguage.hebrew ? 'כרטיס אושר' : 'Card authorized';
  static String get paymentCancelled => language == AppLanguage.hebrew ? 'התשלום בוטל' : 'Payment Cancelled';
  static String get cashAccepted => language == AppLanguage.hebrew ? 'מזומן התקבל ונרשם' : 'Cash accepted and recorded';
  static String get sendBackAmount => language == AppLanguage.hebrew ? 'החזר את הסכום שהוכנס' : 'Send back the same amount entered';
  static String get buyMeSuccess => language == AppLanguage.hebrew ? 'ביי מי הצליח' : 'BuyMe success';
  static String get beastdaaSuccess => language == AppLanguage.hebrew ? 'ביסטדא הצליח' : 'Beastdaa success';

  // Store selection
  static String get selectStore => language == AppLanguage.hebrew ? 'בחר חנות' : 'Select Store';
  static String get selectStoreUnlock => language == AppLanguage.hebrew ? 'בחירת החנות פתוחה!' : 'Store selection unlocked!';

  static String get devMode => language == AppLanguage.hebrew ? 'מצב מפתח' : 'Developer Mode';
  static String get logs => language == AppLanguage.hebrew ? 'לוגים' : 'Logs';
}
