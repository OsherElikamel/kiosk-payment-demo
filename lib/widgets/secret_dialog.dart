// widgets/secret_store_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for haptic
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../core/store_config.dart';
import '../screens/store_picker_app.dart';
import 'big_button.dart';

class SecretStorePickerDialog extends StatelessWidget {
  const SecretStorePickerDialog({super.key});

  Future<void> _openStorePicker(BuildContext context) async {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(); // close dialog

    final stores = await StoreConfig.loadStores();
    if (!context.mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StorePickerApp(stores: stores),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cool icon with subtle glow effect
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.admin_panel_settings_rounded,
                size: 80,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 48),

            // Title — same as WelcomeScreen & PaymentMethodScreen
            Text(
              AppStrings.devMode,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColors.textTitle,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Subtitle — slightly larger and elegant
            Text(
              AppStrings.selectStoreUnlock,
              style: TextStyle(
                fontSize: 26,
                color: AppColors.textTitle,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 60),

            // Your beautiful BigButton — perfectly centered
            BigButton(
              label: AppStrings.selectStore,
              onPressed: () => _openStorePicker(context),
            ),

            const SizedBox(height: 24),

            // Subtle cancel button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.cancel,
                style: TextStyle(
                  fontSize: 19,
                  color: AppColors.iconLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}