import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/app_strings.dart';
import 'core/store_config.dart';
import 'providers/kiosk_provider.dart';
import 'screens/welcome_screen.dart';
import 'theme.dart';

class PaytagApp extends StatelessWidget {
  final StoreConfig storeConfig;

  const PaytagApp({super.key, required this.storeConfig});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KioskProvider(storeConfig),
      child: MaterialApp(
        title: AppStrings.title(storeConfig.storeName),
        theme: buildAppTheme(),
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}
