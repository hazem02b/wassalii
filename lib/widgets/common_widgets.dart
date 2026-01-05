import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../config/app_theme.dart';

/// Avatar utilisateur - Design identique au web
class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name?.split(' ')
        .take(2)
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join() ?? 'U';

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: imageUrl != null
          ? ClipOval(
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitials(initials),
              ),
            )
          : _buildInitials(initials),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildInitials(String initials) {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Liste d'options - Design identique au web
class OptionsList extends StatelessWidget {
  final List<OptionItem> items;

  const OptionsList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            onTap: item.onTap,
            leading: item.icon != null
                ? Icon(
                    item.icon,
                    color: item.iconColor ?? AppColors.textSecondary,
                  )
                : null,
            title: Text(
              item.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: item.textColor ?? AppColors.textPrimary,
              ),
            ),
            subtitle: item.subtitle != null
                ? Text(
                    item.subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
            trailing: item.trailing ??
                (item.onTap != null
                    ? const Icon(
                        Icons.chevron_right,
                        color: AppColors.textLight,
                      )
                    : null),
          );
        },
      ),
    );
  }
}

class OptionItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const OptionItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.textColor,
    this.trailing,
    this.onTap,
  });
}

/// Section Header - Design identique au web
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
