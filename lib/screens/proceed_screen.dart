import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../providers/kiosk_provider.dart';
import '../widgets/big_button.dart';
import '../widgets/scanned_items_list.dart';
import 'payment_method_screen.dart';

class ProceedScreen extends StatelessWidget {
  const ProceedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<KioskProvider>();
    final textTheme = Theme.of(context).textTheme;

    if (p.scanned.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_basket_outlined, size: 80, color: AppColors.textLight),
                const SizedBox(height: 24),
                Text(
                  AppStrings.noItemsFound,
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                BigButton(
                  label: AppStrings.restartLabel,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
            const SizedBox(height: 20),
            Padding(
              padding: AppSpacing.screenHorizontal,
              child: Text(
                AppStrings.itemsFoundInBags(p.scanned.length),
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ScannedItemsList(
                scannedItems: p.scanned,
                formatPrice: p.formatPrice,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 16, 40, 30),
              child: Column(
                children: [
                  Text(
                    AppStrings.totalPrice,
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.formatPrice(p.total),
                    style: textTheme.headlineLarge?.copyWith(fontSize: 56),
                  ),
                  const SizedBox(height: 24),
                  BigButton(
                    label: AppStrings.proceedToPayment,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaymentMethodScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
