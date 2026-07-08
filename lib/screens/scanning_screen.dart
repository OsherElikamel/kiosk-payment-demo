import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../providers/kiosk_provider.dart';
import '../widgets/big_button.dart';
import '../widgets/scanned_items_list.dart';
import 'proceed_screen.dart';

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  State<ScanningScreen> createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KioskProvider>().startScan();
    });
  }

  void _navigateAfterDelay() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProceedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<KioskProvider>(
      builder: (context, p, _) {
        if (!p.scanning && p.scanned.isNotEmpty && !_hasNavigated) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _navigateAfterDelay());
        }

        final scanCameBackEmpty = !p.scanning && p.scanned.isEmpty;

        Widget centerContent;
        if (p.scanning) {
          centerContent = const CircularProgressIndicator(
            strokeWidth: 6,
            color: AppColors.textTitle,
          );
        } else if (scanCameBackEmpty) {
          // Dead-end guard: a kiosk has no back button, so an empty scan
          // must always offer a way out.
          centerContent = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_basket_outlined,
                  size: 80, color: AppColors.textLight),
              const SizedBox(height: 24),
              Text(
                AppStrings.insertItemsPrompt,
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              BigButton(
                label: AppStrings.restartLabel,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        } else {
          centerContent = ScannedItemsList(
            scannedItems: p.scanned,
            formatPrice: p.formatPrice,
          );
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Padding(
                  padding: AppSpacing.screenHorizontal,
                  child: Text(
                    scanCameBackEmpty
                        ? AppStrings.noItemsFound
                        : AppStrings.scanningInProcess,
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: 38,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: centerContent,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
