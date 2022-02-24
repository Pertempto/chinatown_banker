import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PropertyNumberItem extends StatelessWidget {
  final int propertyNumber;
  final VoidCallback? onTap;
  final bool small;

  const PropertyNumberItem({Key? key, required this.propertyNumber, this.onTap, this.small = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle textStyle = small ? textTheme.subtitle1! : textTheme.headline6!;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: small ? 4 : 8, horizontal: small ? 6 : 12),
        decoration: ShapeDecoration(
          shape:  ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(small ? 12 : 24))),
          color: Colors.blue.shade700,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(MdiIcons.store, color: colorScheme.onPrimary, size: small ? 24 : 32),
            const SizedBox(width: 8),
            Text('#$propertyNumber', style: textStyle.copyWith(color: colorScheme.onPrimary)),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
