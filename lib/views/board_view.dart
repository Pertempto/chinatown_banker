import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../models/board.dart';
import '../models/business.dart';
import '../models/game.dart';
import 'item.dart';

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
  late double cellSize;
  late TransformationController controller;
  final GlobalKey _viewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_viewerKey.currentContext != null) {
        Size size = _viewerKey.currentContext!.size!;
        // This centers the board for some reason.
        setState(() {
          controller.value.setTranslation(vector.Vector3(
            (size.width - width) * 0.5,
            (size.height - height) * 0.5,
            0,
          ));
        });
      }
    });

    controller = TransformationController(Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MediaQueryData mq = MediaQuery.of(context);
    width = mq.size.width;
    height = mq.size.height;
    double ratio = height / width;
    if (ratio >= 0.7) {
      cellSize = width * 0.04;
    } else {
      // gracefully handle horizontal layouts.
      cellSize = (height / 0.7) * 0.04;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        if (!game.isStarted)
          Center(
              child: Text(
            'Game Not Started',
            style: textTheme.headline2,
            textAlign: TextAlign.center,
          ))
        else
          InteractiveViewer(
            key: _viewerKey,
            constrained: false,
            maxScale: 10,
            minScale: 0.01,
            transformationController: controller,
            child: Container(
              width: width,
              height: height,
              color: Colors.white,
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(cellSize),
                decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(cellSize * 2))),
                  color: Colors.grey.shade300,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    11,
                    (y) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        17,
                        (x) {
                          int propertyNumber = getPropertyNumber(x, y);
                          bool isProperty = propertyNumber != 0;
                          bool isSelected = isProperty && propertyNumber == selectedPropertyNumber;
                          ShopType? shopType = game.board.getShopType(propertyNumber);
                          Color propertyColor = isProperty ? Colors.grey.shade400 : Colors.transparent;
                          if (shopType != null) {
                            propertyColor = shopTypeColor(shopType);
                          }
                          String? ownerId = game.board.getOwnerId(propertyNumber);
                          Border circleBorder = Border.all(color: Colors.transparent, width: 0);
                          if (ownerId != null) {
                            circleBorder = Border.all(color: Colors.grey, width: 0);
                          }
                          if (isSelected) {
                            circleBorder = Border.all(color: Colors.black, width: cellSize * 0.03);
                          }
                          Color ownershipColor = game.players[ownerId]?.tokenColor ?? Colors.transparent;
                          Color textColor = ownershipColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (game.isPlaying && isProperty) {
                                selectedPropertyNumber = propertyNumber;
                              } else {
                                selectedPropertyNumber = 0;
                              }
                            }),
                            child: Padding(
                              padding: const EdgeInsets.all(0.5),
                              child: Container(
                                height: cellSize,
                                width: cellSize,
                                decoration: ShapeDecoration(
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(cellSize * 0.3))),
                                  color: propertyColor,
                                ),
                                alignment: Alignment.center,
                                child: Stack(
                                  children: [
                                    if (isProperty)
                                      Center(
                                        child: Container(
                                          height: cellSize * 0.8,
                                          width: cellSize * 0.8,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(cellSize * 0.4)),
                                            color: ownershipColor,
                                            border: circleBorder,
                                          ),
                                          child: Center(
                                            child: Text(
                                              propertyNumber == 0 ? '' : propertyNumber.toString(),
                                              style: textTheme.headline6!
                                                  .copyWith(fontSize: cellSize * 0.4, color: textColor),
                                              textAlign: TextAlign.center,
                                            ),
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
          ),
        if (selectedPropertyNumber != 0)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: Colors.grey, width: 2),
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _setOwnerButton()),
                  Expanded(
                    child: _setShopButton(disabled: game.board.getOwnerId(selectedPropertyNumber) == null),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  _setOwnerButton() {
    String? ownerId = game.board.getOwnerId(selectedPropertyNumber);
    return TextButton(
      onPressed: _setOwner,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(MdiIcons.account),
          const SizedBox(width: 8),
          ownerId != null ? Text(game.players[ownerId]?.name ?? '') : const Text('Set Owner'),
        ],
      ),
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
                Item(
                  title: 'None',
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      game.board.setOwnerId(selectedPropertyNumber, null);
                      game.saveBoard();
                    });
                  },
                ),
                ...game.players.values.map((player) => Item(
                      title: player.name,
                      leading: Container(
                        margin: const EdgeInsets.all(12),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: player.tokenColor,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            width: 1,
                            color: player.tokenColor == Colors.white ? Colors.grey : Colors.transparent,
                          ),
                          // color: Color(player.colorValue),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          game.board.setOwnerId(selectedPropertyNumber, player.id);
                          game.saveBoard();
                        });
                      },
                    ))
              ],
            ),
          );
        });
  }

  _setShopButton({bool disabled = false}) {
    ShopType? shopType = game.board.getShopType(selectedPropertyNumber);

    return TextButton(
      onPressed: disabled ? null : _setShop,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(MdiIcons.domain),
          const SizedBox(width: 8),
          shopType != null ? Text(shopTypeName(shopType)) : const Text('Set Shop'),
        ],
      ),
    );
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
                Item(
                  title: 'None',
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      game.board.setShopType(selectedPropertyNumber, null);
                      game.saveBoard();
                    });
                  },
                ),
                ...ShopType.values.map((shopType) => Item(
                      title: shopTypeName(shopType),
                      backgroundColor: shopTypeColor(shopType),
                      outlined: false,
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          game.board.setShopType(selectedPropertyNumber, shopType);
                          game.saveBoard();
                        });
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
