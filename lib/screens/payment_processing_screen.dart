import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/app_dimensions.dart';
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../providers/kiosk_provider.dart';
import '../services/logger.dart';
import '../services/payments/payment_method.dart';
import '../widgets/big_button.dart';
import 'payment_result_screen.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  String _message = '';
  bool _processing = true;

  @override
  void initState() {
    super.initState();
    final p = context.read<KioskProvider>();
    _message = AppStrings.processingPaymentTemplate(
        p.selectedPayment?.localizedDisplayName);
    _processPayment();
  }

  Future<void> _processPayment() async {
    final p = Provider.of<KioskProvider>(context, listen: false);

    PaymentResult result;
    try {
      result = await p.processPayment();
    } catch (e, stack) {
      await Logger.e('Payment processing failed: $e', stack);
      result = PaymentResult(
          success: false, message: AppStrings.paymentProcessingError);
    }

    if (!mounted || result.cancelled) return;

    setState(() => _processing = false);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PaymentResultScreen(result: result)),
    );
  }

  void _cancel() {
    final p = context.read<KioskProvider>();
    p.requestPaymentCancel();
    p.reset();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: AppSpacing.boxConstraintsPage,
            padding: AppSpacing.screenHorizontal,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    _message,
                    style: textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(
                        strokeWidth: 6,
                        color: AppColors.textTitle,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppStrings.processingPayment,
                        style: textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  if (_processing)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: BigButton(
                        label: AppStrings.cancel,
                        onPressed: _cancel,
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
