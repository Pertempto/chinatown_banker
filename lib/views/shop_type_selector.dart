import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/business.dart';

class ShopTypeSelector extends StatelessWidget {
  const ShopTypeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Shop Type'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              children: ShopType.values
                  .map((shopType) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, shopType),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              color: shopTypeColor(shopType),
                            ),
                            child: Row(
                              children: [
                                Text(shopTypeName(shopType),
                                    style: textTheme.headline4!.copyWith(color: colorScheme.onPrimary)),
                                const Spacer(),
                                Text('${shopTypeMaxSize(shopType)}',
                                    style: textTheme.headline5!.copyWith(color: colorScheme.onPrimary)),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
