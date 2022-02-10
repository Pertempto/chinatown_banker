import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../models/business.dart';
import '../models/game.dart';
import 'item.dart';
import 'outlined_item.dart';

const List<List<int>> propertyNumbers = [
  [00, 01, 02, 00, 00, 16, 17, 18, 00, 28, 29, 30, 00, 43, 44, 45, 46],
  [00, 03, 04, 05, 00, 19, 20, 21, 00, 31, 32, 33, 00, 47, 48, 49, 50],
  [06, 07, 08, 09, 00, 22, 23, 00, 00, 34, 35, 36, 00, 51, 52, 53, 54],
  [10, 11, 12, 00, 00, 24, 25, 00, 00, 00, 37, 38, 39, 00, 00, 55, 56],
  [13, 14, 15, 00, 00, 26, 27, 00, 00, 00, 40, 41, 42, 00, 00, 57, 58],
  [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
  [00, 00, 00, 00, 00, 00, 59, 60, 00, 00, 00, 71, 72, 73, 74, 00, 00],
  [00, 00, 00, 00, 00, 00, 61, 62, 00, 00, 00, 75, 76, 77, 78, 00, 00],
  [00, 00, 00, 00, 00, 00, 63, 64, 65, 00, 00, 79, 80, 81, 82, 00, 00],
  [00, 00, 00, 00, 00, 00, 66, 67, 68, 00, 00, 83, 84, 85, 00, 00, 00],
  [00, 00, 00, 00, 00, 00, 00, 69, 70, 00, 00, 00, 00, 00, 00, 00, 00],
];

class BoardView extends StatefulWidget {
  final Game game;
  final Function(int)? onPropertyTap;

  const BoardView({Key? key, required this.game, this.onPropertyTap}) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  late Game game = widget.game;
  int selectedPropertyNumber = 0;
  late double width;
  late double height;
  late TransformationController controller;
  final GlobalKey _viewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Size size = _viewerKey.currentContext!.size!;
      // This centers the board for some reason.
      setState(() {
        controller.value.setTranslation(vector.Vector3(
          (size.width - width * 0.5) * 0.5,
          (size.height - height * 0.5) * 0.5,
          0,
        ));
      });
    });

    controller = TransformationController(Matrix4(0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 0.5, 0, 0, 0, 0, 1));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MediaQueryData mq = MediaQuery.of(context);
    width = mq.size.width * mq.devicePixelRatio;
    height = mq.size.height * mq.devicePixelRatio;
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    String? selectedPropertyOwnerId = game.board.getOwnerId(selectedPropertyNumber);
    Color? selectedPropertyOwnerColor = game.players[selectedPropertyOwnerId]?.color;
    ShopType? selectedPropertyShopType = game.board.getShopType(selectedPropertyNumber);
    return Stack(
      children: [
        InteractiveViewer(
          key: _viewerKey,
          constrained: false,
          maxScale: 1.5,
          minScale: 0.5,
          transformationController: controller,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            // color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                11,
                (y) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    17,
                    (x) {
                      int propertyNumber = propertyNumbers[y][x];
                      bool isProperty = propertyNumber != 0;
                      ShopType? shopType = game.board.getShopType(propertyNumber);
                      Color propertyColor = isProperty ? Colors.grey.shade400 : Colors.transparent;
                      if (shopType != null) {
                        propertyColor = shopTypeColor(shopType);
                      }
                      String? ownerId = game.board.getOwnerId(propertyNumber);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (game.isPlaying) {
                            selectedPropertyNumber = propertyNumber;
                            if (ownerId == null) {
                              // shortcut: if there is no owner, select one first
                              _setOwner();
                            }
                          } else {
                            selectedPropertyNumber = 0;
                          }
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(0.5),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              color: propertyColor,
                            ),
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    propertyNumbers[y][x] == 0 ? '' : propertyNumbers[y][x].toString(),
                                    style: textTheme.headline6!.copyWith(color: Colors.white),
                                  ),
                                ),
                                if (isProperty && ownerId != null)
                                  Center(
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(14)),
                                        color: game.players[ownerId]?.color ?? Colors.transparent,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        if (selectedPropertyNumber != 0)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: Colors.grey, width: 2),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedPropertyNumber.toString(), style: textTheme.headline6),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: _setOwner,
                        icon: const Icon(MdiIcons.account),
                        label: const Text('Set Owner'),
                      ),
                      const Spacer(),
                      if (selectedPropertyOwnerColor != null)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: selectedPropertyOwnerColor,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              width: 1,
                              color: selectedPropertyOwnerColor == Colors.white ? Colors.grey : Colors.transparent,
                            ),
                            // color: Color(player.colorValue),
                          ),
                        ),
                    ],
                  ),
                  if (selectedPropertyOwnerId != null)
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _setShop,
                          icon: const Icon(MdiIcons.domain),
                          label: const Text('Set Shop'),
                        ),
                        const Spacer(),
                        if (selectedPropertyShopType != null)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: shopTypeColor(selectedPropertyShopType),
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Text(shopTypeName(selectedPropertyShopType),
                                style: textTheme.headline6!.copyWith(color: colorScheme.onPrimary)),
                          )
                      ],
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  _setOwner() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedItem(
                  title: 'None',
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => game.board.setOwnerId(selectedPropertyNumber, null));
                  },
                ),
                ...game.players.values.map((player) => OutlinedItem(
                      title: player.name,
                      leading: Container(
                        margin: const EdgeInsets.all(12),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: player.color,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            width: 1,
                            color: player.color == Colors.white ? Colors.grey : Colors.transparent,
                          ),
                          // color: Color(player.colorValue),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => game.board.setOwnerId(selectedPropertyNumber, player.id));
                      },
                    ))
              ],
            ),
          );
        });
  }

  _setShop() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
          contentPadding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedItem(
                  title: 'None',
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() => game.board.setShopType(selectedPropertyNumber, null));
                  },
                ),
                ...ShopType.values.map((shopType) => Item(
                      title: shopTypeName(shopType),
                      backgroundColor: shopTypeColor(shopType),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() => game.board.setShopType(selectedPropertyNumber, shopType));
                      },
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}