import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final IconData? iconData;
  final Widget? leading;
  final Widget? trailing;
  final String? subtitle;
  final Widget? content;
  final VoidCallback? onTap;

  const Item({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.white,
    this.textStyle,
    this.iconData,
    this.leading,
    this.trailing,
    this.subtitle,
    this.content,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(left: leading == null ? 16 : 0),
          width: double.infinity,
          decoration: ShapeDecoration(
            shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
            color: backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (leading != null) leading!,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      title,
                      style: (textStyle ?? textTheme.headline4!).copyWith(
                        color: backgroundColor.computeLuminance() > 0.5 ? Colors.grey.shade800 : Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (subtitle != null) Text(subtitle!, style: textTheme.bodyText1),
                  if (iconData != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(iconData,
                          size: 32, color: backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                    ),
                  if (trailing != null) trailing!,
                ],
              ),
              if (content != null) content!
            ],
          ),
        ),
      ),
    );
  }
}
