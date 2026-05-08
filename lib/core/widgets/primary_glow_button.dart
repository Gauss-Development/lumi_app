import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
<<<<<<< HEAD
=======
import 'package:lumi/core/theme/app_text_styles.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e

class PrimaryGlowButton extends StatelessWidget {
  const PrimaryGlowButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.expanded = true,
<<<<<<< HEAD
=======
    this.glowColor,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool expanded;
<<<<<<< HEAD

  @override
  Widget build(BuildContext context) {
    final button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.35),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: icon ?? const SizedBox.shrink(),
        label: Text(label),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.midnight.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
=======
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final Color color = glowColor ?? AppColors.coral;

    final Widget content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.33),
            blurRadius: 40,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 80,
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.16),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
          minimumSize: const Size.fromHeight(58),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
            side: BorderSide(color: color.withValues(alpha: 0.36)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              icon!,
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: Colors.white.withValues(alpha: onPressed == null ? 0.45 : 0.9),
              ),
            ),
          ],
        ),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      ),
    );

    if (expanded) {
<<<<<<< HEAD
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
=======
      return SizedBox(width: double.infinity, child: content);
    }

    return content;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  }
}
