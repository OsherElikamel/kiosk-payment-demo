import 'package:flutter/material.dart';
import 'app.dart';
import 'core/store_config.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  StoreConfig config;

  try {
    final stores = await StoreConfig.loadStores();

    const storeEnv = String.fromEnvironment('store');
    final storeArg = args.where((a) => a.startsWith('--store=')).firstOrNull;
    final targetId = storeEnv.isNotEmpty ? storeEnv : storeArg?.substring(8);

    if (targetId != null && targetId.isNotEmpty) {
      config = stores.firstWhere(
        (s) => s.storeId == targetId,
        orElse: () => stores.first,
      );
    } else {
      config = stores.firstWhere(
        (s) => s.storeId == 'STORE_001',
        orElse: () => stores.first,
      );
    }
  } catch (_) {
    config = await StoreConfig.load();
  }

  runApp(PaytagApp(storeConfig: config));
}
