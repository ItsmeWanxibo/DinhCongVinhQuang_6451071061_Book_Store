import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final bool outlined;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.color,
    this.outlined = false,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color ?? AppColors.primary),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
              : Text(text,
              style: TextStyle(
                  color: color ?? AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white))
            : Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ),
    );
  }
}