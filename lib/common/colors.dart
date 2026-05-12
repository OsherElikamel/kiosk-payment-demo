import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.pink;
  static const Color primaryLight = Color(0xFFE02074);
  static const Color primaryDark = Color(0xFFB22764);
  static const Color primaryAccent = Colors.pinkAccent;

  static const Color accent = primary;

  static const Color textPrimary = Color(0xFF0D2B59);
  static const Color textTitle = Color(0xDD000000);
  static const Color textBody = Color(0x8A000000);
  static const Color textLight = Color(0x73000000);

  static const Color background = Colors.white;
  static const Color card = Colors.white;
  static const Color transparent = Colors.transparent;
  static Color iconLight = Colors.grey[600]!;

  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x2E000000);
  static const Color shadowHeavy = Color(0x73000000);
  static const Color shadowTop = Color(0x1A000000);

  static const Color link = primary;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const MaterialColor primarySwatch = MaterialColor(
    0xFFE02074,
    <int, Color>{
      50: Color(0xFFFFE5EE),
      100: Color(0xFFFFB8D1),
      200: Color(0xFFFF8AB4),
      300: Color(0xFFFF5C97),
      400: Color(0xFFFF337D),
      500: Color(0xFFE02074),
      700: Color(0xFFB81A5C),
      800: Color(0xFFA41553),
      900: Color(0xFF8F1147),
    },
  );
}