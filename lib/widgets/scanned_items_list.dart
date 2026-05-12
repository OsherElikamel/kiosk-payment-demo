import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../common/app_dimensions.dart';
import '../common/colors.dart';
import '../models/tag_item.dart';

class ScannedItemsList extends StatelessWidget {
  final List<TagItem> scannedItems;
  final String Function(double) formatPrice;

  const ScannedItemsList({
    super.key,
    required this.scannedItems,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemTotalWidth = AppSpacing.itemsWidth + 32;
    final itemsPerRow = (screenWidth / itemTotalWidth).floor().clamp(1, scannedItems.length);
    final fitsInOneRow = scannedItems.length <= itemsPerRow;

    if (fitsInOneRow) {
      return _buildSingleRow(context);
    }
    return _buildScrollableGrid(context);
  }

  Widget _buildSingleRow(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: scannedItems.map((item) => _buildItemCard(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildScrollableGrid(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: scannedItems.map((item) => _buildItemCard(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildItemCard(TagItem item) {
    return Container(
      width: AppSpacing.itemsWidth,
      height: AppSpacing.itemsHeight,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.textLight,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                item.assetPath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBody,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  formatPrice(item.price),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
