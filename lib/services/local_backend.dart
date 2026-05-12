import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import '../common/app_assets.dart';
import '../common/app_strings.dart';
import '../models/tag_item.dart';

class LocalBackend {
  final Random _random = Random();
  Map<String, TagItem>? _tagDatabaseCache;

  Future<List<String>> getAvailableInputFilesReliable() async {
    final List<String> existing = [];

    for (final path in AppAssets.tagInputFiles) {
      try {
        final byteData = await rootBundle.load(path);
        if (byteData.lengthInBytes == 0) continue;

        final bytes = byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        );

        final excel = Excel.decodeBytes(bytes);
        final sheet = excel.tables['Sheet1'];

        if (sheet != null && sheet.rows.isNotEmpty) {
          existing.add(path);
        }
      } on FlutterError catch (_) {
        // Asset not found
      } catch (_) {
        // Parsing error
      }
    }

    return existing;
  }

  Future<Map<String, TagItem>> _loadTagDatabase() async {
    if (_tagDatabaseCache != null) return _tagDatabaseCache!;

    try {
      final byteData = await rootBundle.load(AppAssets.dbPath);
      final bytes = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables['Sheet1'];
      if (sheet == null) return {};

      final Map<String, TagItem> map = {};

      for (var i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        if (row.length < 3) continue;

        final tagCell = row[0];
        final priceCell = row[1];
        final imageCell = row[2];

        if (tagCell?.value == null) continue;

        final tagId = tagCell!.value.toString().trim();
        final imageFile = imageCell?.value?.toString().trim() ?? '';
        final price = priceCell?.value is num
            ? (priceCell!.value as num).toDouble()
            : double.tryParse(priceCell?.value?.toString() ?? '') ?? 0.0;
        if (price <= 0) continue;

        final assetPath = AppAssets.imagePath(imageFile);
        final baseName = imageFile.split('.').first;
        final numberPart = baseName.replaceFirst('image', '');
        final productNumber = int.tryParse(numberPart) ?? 0;
        final name = AppStrings.productName(productNumber);

        map[tagId] = TagItem(
          tagId: tagId,
          assetPath: assetPath,
          price: price,
          name: name,
        );
      }

      _tagDatabaseCache = map;
      return map;
    } catch (e) {
      debugPrint('Failed to load tag database: $e');
      return {};
    }
  }

  Future<List<TagItem>> scanOnce() async {
    final availableFiles = await getAvailableInputFilesReliable();

    if (availableFiles.isEmpty) {
      return [];
    }

    final chosenFile = availableFiles[_random.nextInt(availableFiles.length)];

    try {
      final fileData = await rootBundle.load(chosenFile);
      final bytes = fileData.buffer.asUint8List(
        fileData.offsetInBytes,
        fileData.lengthInBytes,
      );

      final excel = Excel.decodeBytes(bytes);
      final sheet = excel.tables['Sheet1'];
      if (sheet == null) return [];

      final List<String> tagIds = [];
      for (final row in sheet.rows) {
        if (row.isEmpty || row[0] == null || row[0]!.value == null) continue;
        final rawTag = row[0]!.value.toString().trim();
        if (rawTag.isNotEmpty) {
          tagIds.add(rawTag);
        }
      }

      if (tagIds.isEmpty) return [];

      final tagMap = await _loadTagDatabase();
      final List<TagItem> items = [];

      for (final tag in tagIds) {
        final item = tagMap[tag];
        if (item != null) {
          items.add(item);
        } else {
          items.add(TagItem(
            tagId: tag,
            assetPath: AppAssets.logoPath,
            price: 0.0,
            name: AppStrings.unknownItem,
          ));
        }
      }

      return items;
    } catch (_) {
      return [];
    }
  }
}
