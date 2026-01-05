import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../config/app_theme.dart';

/// Card personnalisée - Design identique au web
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium),
        border: border ?? Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium),
        child: card,
      );
    }

    return card;
  }
}

/// Badge de statut - comme web
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  factory StatusBadge.success(String text) {
    return StatusBadge(
      text: text,
      color: AppColors.success,
      icon: Icons.check_circle,
    );
  }

  factory StatusBadge.warning(String text) {
    return StatusBadge(
      text: text,
      color: AppColors.warning,
      icon: Icons.warning,
    );
  }

  factory StatusBadge.error(String text) {
    return StatusBadge(
      text: text,
      color: AppColors.error,
      icon: Icons.error,
    );
  }

  factory StatusBadge.info(String text) {
    return StatusBadge(
      text: text,
      color: AppColors.info,
      icon: Icons.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
