import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';

class RitualPromptCard extends StatelessWidget {
  const RitualPromptCard({
    required this.suggestion,
    required this.onSend,
    required this.onDismiss,
    super.key,
  });

  final RitualSuggestion suggestion;
  final VoidCallback onSend;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final Color accent = switch (suggestion.kind) {
      RitualKind.morning => AppColors.peach,
      RitualKind.evening => AppColors.softLavender,
      RitualKind.checkIn => AppColors.mint,
    };
    final IconData icon = switch (suggestion.kind) {
      RitualKind.morning => Icons.wb_sunny_outlined,
      RitualKind.evening => Icons.nights_stay_outlined,
      RitualKind.checkIn => Icons.favorite_border_rounded,
    };

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: accent.withValues(alpha: 0.12), blurRadius: 36),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.14),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  suggestion.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  suggestion.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: onSend,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: accent.withValues(alpha: 0.2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(suggestion.actionLabel),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'Later today',
                      onPressed: onDismiss,
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.textFaint,
                        minimumSize: const Size(36, 36),
                      ),
                      icon: const Icon(Icons.close_rounded, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
