import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/app_strings.dart';
import 'core/store_config.dart';
import 'providers/kiosk_provider.dart';
import 'screens/welcome_screen.dart';
import 'theme.dart';
import 'widgets/idle_reset.dart';

class PaytagApp extends StatefulWidget {
  final StoreConfig storeConfig;

  const PaytagApp({super.key, required this.storeConfig});

  @override
  State<PaytagApp> createState() => _PaytagAppState();
}

class _PaytagAppState extends State<PaytagApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final KioskProvider _provider = KioskProvider(widget.storeConfig);

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _resetToWelcome() {
    final nav = _navigatorKey.currentState;
    if (nav == null || !nav.canPop()) return;
    _provider.reset();
    nav.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      // Rebuilding on the language notifier makes a runtime toggle apply
      // everywhere, including text direction.
      child: ValueListenableBuilder<AppLanguage>(
        valueListenable: AppStrings.currentLanguage,
        builder: (context, lang, _) => MaterialApp(
          title: AppStrings.title(widget.storeConfig.storeName),
          theme: buildAppTheme(),
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          builder: (context, child) => Directionality(
            textDirection: lang == AppLanguage.hebrew
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: IdleReset(
              onIdle: _resetToWelcome,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
          home: const WelcomeScreen(),
        ),
      ),
    );
  }
}
