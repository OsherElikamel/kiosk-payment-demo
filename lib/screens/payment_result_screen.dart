import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../providers/kiosk_provider.dart';
import '../services/payments/payment_method.dart';
import '../widgets/big_button.dart';
import 'demo_ended_screen.dart';

class PaymentResultScreen extends StatelessWidget {
  final PaymentResult result;

  const PaymentResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<KioskProvider>(context, listen: false);
    final success = result.success;
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
                  Icon(
                    success ? Icons.check_circle_outline : Icons.error_outline,
                    size: 80,
                    color: success ? Colors.green : AppColors.primaryAccent,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    success ? AppStrings.paymentSuccessful : AppStrings.paymentFailed,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (!success)
                    Text(
                      result.message,
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  BigButton(
                    label: AppStrings.continueLabel,
                    onPressed: () {
                      if (success) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const DemoEndedScreen(),
                          ),
                        );
                      } else {
                        p.reset();
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
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
