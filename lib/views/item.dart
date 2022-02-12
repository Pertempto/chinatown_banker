import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final bool outlined;
  final IconData? iconData;
  final Widget? leading;
  final Widget? trailing;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool small;

  const Item({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.white,
    this.outlined = true,
    this.small = false,
    this.iconData,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(bottom: small ? 2 : 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: leading == null ? 16 : 0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: outlined
                ? Border.all(width: small ? 1 : 2, color: Colors.grey)
                : null,
            color: backgroundColor,
          ),
          child: Row(
            children: [
              if (leading != null) leading!,
              Padding(
                padding: EdgeInsets.symmetric(vertical: small ? 1 : 4),
                child: Text(title,
                    style: (small ? textTheme.headline6 : textTheme.headline4)!
                        .copyWith(
                            color: backgroundColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white)),
              ),
              const Spacer(),
              if (subtitle != null) Text(subtitle!, style: textTheme.bodyText1),
              if (iconData != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(iconData,
                      size: 32,
                      color: backgroundColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white),
                ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
