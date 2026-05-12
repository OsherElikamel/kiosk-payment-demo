import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../providers/kiosk_provider.dart';
import '../widgets/big_button.dart';

class DemoEndedScreen extends StatelessWidget {
  const DemoEndedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<KioskProvider>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: AppSpacing.boxConstraintsPage,
            padding: AppSpacing.screenHorizontal,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    AppStrings.demoFinished,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  BigButton(
                    label: AppStrings.restartLabel,
                    onPressed: () {
                      p.reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
