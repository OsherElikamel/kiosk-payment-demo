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
    final methodName = p.selectedPayment?.localizedDisplayName;

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
                    color: success ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    success
                        ? AppStrings.paymentSuccessful
                        : AppStrings.paymentFailed,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  if (success)
                    Text(
                      '${AppStrings.totalPaid}: ${p.formatPrice(p.total)}'
                      '${methodName != null ? ' · $methodName' : ''}',
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(
                      result.message,
                      style: textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  if (success)
                    BigButton(
                      label: AppStrings.continueLabel,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const DemoEndedScreen(),
                          ),
                        );
                      },
                    )
                  else ...[
                    // Cart is kept: the PaymentMethodScreen is still on the
                    // stack below, so popping returns to it with items intact.
                    BigButton(
                      label: AppStrings.tryAnotherMethod,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        p.reset();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        AppStrings.cancel,
                        style: const TextStyle(
                          color: AppColors.primaryAccent,
                          fontSize: 19,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryAccent,
                          decorationThickness: 1,
                        ),
                      ),
                    ),
                  ],
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
