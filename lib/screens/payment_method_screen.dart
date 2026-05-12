import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../providers/kiosk_provider.dart';
import '../widgets/big_button.dart';
import 'payment_processing_screen.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontSize: 19,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryAccent,
                      decorationThickness: 1,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  constraints: AppSpacing.boxConstraintsPage,
                  padding: AppSpacing.screenHorizontal,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer<KioskProvider>(
                          builder: (_, p, __) {
                            return Text(
                              AppStrings.choosePaymentMethod(p.selectedPayment?.displayName),
                              style: textTheme.headlineLarge?.copyWith(height: 1.2),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Consumer<KioskProvider>(
                          builder: (_, p, __) {
                            return Column(
                              children: p.availableMethods.map((m) {
                                final selected = p.selectedPayment?.id == m.id;

                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: selected ? AppColors.textPrimary : AppColors.textLight,
                                      width: selected ? 2.5 : 1.2,
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      m.displayName,
                                      style: textTheme.titleLarge,
                                    ),
                                    trailing: selected
                                        ? const Icon(Icons.check_circle, size: 32, color: Colors.blue)
                                        : null,
                                    onTap: () => p.setPaymentMethod(m.id),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 80),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Consumer<KioskProvider>(
                            builder: (_, p, __) => BigButton(
                              label: AppStrings.continueLabel,
                              onPressed: () {
                                if (p.selectedPayment == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(AppStrings.selectPaymentMethodMessage),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const PaymentProcessingScreen(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
