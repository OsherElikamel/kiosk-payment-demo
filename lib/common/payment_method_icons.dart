import 'package:flutter/material.dart';

/// Icon for a payment method id. Ids come from stores.json, so unknown
/// ones get a generic payment icon rather than breaking the list.
IconData paymentMethodIcon(String id) {
  switch (id) {
    case 'credit_card':
      return Icons.credit_card;
    case 'cash':
      return Icons.payments_outlined;
    case 'paypal':
      return Icons.account_balance_wallet_outlined;
    case 'apple_pay':
      return Icons.phone_iphone;
    case 'buyme':
      return Icons.card_giftcard;
    case 'beastdaa':
      return Icons.qr_code_2;
    default:
      return Icons.payment;
  }
}
