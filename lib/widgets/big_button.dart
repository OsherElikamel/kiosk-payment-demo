import 'package:flutter/material.dart';
import '../common/colors.dart';

class BigButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BigButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive width: 25% of screen, but never too small or too large
    final buttonWidth = screenWidth * 0.25;
    final safeWidth = buttonWidth.clamp(120, 350).toDouble();

    return Container(
      width: safeWidth,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryLight,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          shadowColor: AppColors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: 14,
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: screenWidth * 0.045, // adaptive font
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.background,
            ),
          ),
        ),
      ),
    );
  }
}
