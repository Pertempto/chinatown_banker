import 'package:flutter/material.dart';

class OutlinedItem extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final Widget? leading;
  final Widget? trailing;
  final String? subtitle;
  final VoidCallback? onTap;

  const OutlinedItem({
    Key? key,
    required this.title,
    this.iconData,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: leading == null ? 16 : 0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 2, color: Colors.grey),
          ),
          child: Row(
            children: [
              if (leading != null) leading!,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(title, style: textTheme.headline4),
              ),
              const Spacer(),
              if (subtitle != null) Text(subtitle!, style: textTheme.bodyText1),
              if (iconData != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(iconData, size: 32),
                ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
