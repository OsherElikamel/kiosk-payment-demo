import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../providers/kiosk_provider.dart';
import '../widgets/big_button.dart';
import '../widgets/secret_dialog.dart';
import 'scanning_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const int _requiredTaps = 7;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _onLogoTapped() {
    final now = DateTime.now();

    if (_lastTapTime == null ||
        now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }

    _lastTapTime = now;

    if (_tapCount >= _requiredTaps) {
      _tapCount = 0;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const SecretStorePickerDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<KioskProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: AppSpacing.boxConstraintsPage,
            padding: AppSpacing.screenHorizontal,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _onLogoTapped,
                    child: Image.asset(
                      p.storeConfig.logoPath,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    AppStrings.welcome,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.insertItemsPrompt,
                    style: textTheme.headlineLarge?.copyWith(height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: BigButton(
                      label: AppStrings.startLabel,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ScanningScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}