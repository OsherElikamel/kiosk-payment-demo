import 'dart:io';
import 'package:flutter/material.dart';
import '../common/app_assets.dart';
import '../common/app_strings.dart';
import '../common/colors.dart';
import '../core/store_config.dart';
import '../app.dart';
import '../services/logger.dart';
import '../services/payments/payment_method.dart';
import 'welcome_screen.dart';

class StorePickerApp extends StatefulWidget {
  final List<StoreConfig> stores;
  const StorePickerApp({super.key, required this.stores});

  @override
  State<StorePickerApp> createState() => _StorePickerAppState();
}

class LangText extends StatelessWidget {
  final String Function() textBuilder;
  final TextStyle? style;

  const LangText(this.textBuilder, {this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: AppStrings.currentLanguage,
      builder: (_, __, ___) => Text(
        textBuilder(),
        style: style,
      ),
    );
  }
}


class _StorePickerAppState extends State<StorePickerApp> {
  StoreConfig? selectedStore;

  // Switch language (default English)
  AppLanguage currentLanguage = AppLanguage.english;


  Future<void> _openLogsFolder() async {
    final path = await Logger.getLogsDirectoryPath();

    if (Platform.isWindows) {
      String normalizedPath = path.replaceAll('/', '\\');
      await Process.run('explorer', [normalizedPath]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [path]);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [path]);
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      
      child: Scaffold(
        backgroundColor: AppColors.background,
       appBar: AppBar(
        title: LangText(() => AppStrings.selectStore),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textTitle,
        elevation: 0,
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: AppColors.textTitle),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    },
  ),
        actions: [
      IconButton(
        onPressed: () {
          AppStrings.language = AppStrings.language == AppLanguage.english
              ? AppLanguage.hebrew
              : AppLanguage.english;
        },
        icon: ValueListenableBuilder<AppLanguage>(
          valueListenable: AppStrings.currentLanguage,
          builder: (_, lang, __) {
            return lang == AppLanguage.english
                ? Image.asset(AppAssets.flagGb, width: 32)
                : Image.asset(AppAssets.flagIl, width: 32);
          },
        ),
        tooltip: 'Switch language',
      ),
        ],
      ),
      
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          icon: const Icon(Icons.folder_open),
          label: Text(AppStrings.logs),
          onPressed: _openLogsFolder,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.stores.length,
          itemBuilder: (context, index) {
            final store = widget.stores[index];
            final selected = selectedStore?.storeId == store.storeId;
      
            final List<PaymentMethod> visiblePayments =
                store.paymentMethods.where((pm) {
              return store.enabledPaymentMethods.isEmpty ||
                  store.enabledPaymentMethods.contains(pm.id);
            }).toList();
      
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.textPrimary : AppColors.textLight,
                  width: selected ? 2.5 : 1.2,
                ),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        store.logoPath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.store, size: 40),
                      ),
                    ),
                    title: Text(
                      store.storeName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textTitle,
                      ),
                    ),
                    subtitle: Text(
                      store.currency,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textLight,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(Icons.check_circle,
                            size: 32, color: Colors.blue)
                        : null,
                    onTap: () {
                      setState(() => selectedStore = store);
                      Future.delayed(const Duration(milliseconds: 150), () {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaytagApp(storeConfig: store),
                          ),
                        );
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 6),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: visiblePayments.map((pm) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.textLight,
                              width: 1.1,
                            ),
                          ),
                          child: Text(
                            pm.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textTitle,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
