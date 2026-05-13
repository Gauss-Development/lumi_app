import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/theme/app_text_styles.dart';

class PrimaryGlowButton extends StatelessWidget {
  const PrimaryGlowButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.expanded = true,
    this.glowColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool expanded;
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
          BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 80),
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
            if (icon != null) ...<Widget>[icon!, const SizedBox(width: 10)],
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: Colors.white.withValues(
                  alpha: onPressed == null ? 0.45 : 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: content);
    }

    return content;
  }
}
