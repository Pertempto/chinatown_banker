import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordInput extends StatefulWidget {
  final bool isNewPassword;

  const PasswordInput({Key? key, required this.isNewPassword})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  List<Color> colorOptions = [
    Colors.purple.shade700,
    Colors.indigo.shade700,
    Colors.blue.shade700,
    Colors.green.shade700,
    Colors.lime.shade700,
    Colors.orange.shade700,
    Colors.red.shade700,
    Colors.pink.shade700,
    Colors.brown.shade700,
    Colors.grey.shade700,
  ];
  final int maxPasswordLength = 3;
  final double boxSize = 80;

  late List<int> shuffledNumbers;
  List<int> enteredPassword = [];

  @override
  void initState() {
    super.initState();
    shuffledNumbers = List.generate(10, (index) => index);
    shuffledNumbers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewPassword ? 'New Password' : 'Enter Password'),
        actions: [
          if (widget.isNewPassword && enteredPassword.isEmpty)
            IconButton(
              icon: const Icon(MdiIcons.cancel),
              onPressed: () => Navigator.pop(context, ''),
              tooltip: 'No Password',
            ),
          if (enteredPassword.isNotEmpty)
            IconButton(
                icon: const Icon(MdiIcons.check),
                onPressed: () {
                  Navigator.pop(
                      context, enteredPassword.map((i) => i.toString()).join());
                }),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: boxSize,
                  width: 0,
                  margin: const EdgeInsets.symmetric(vertical: 4)),
              ...enteredPassword.map((colorIndex) => Container(
                    width: boxSize,
                    height: boxSize,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      color: colorOptions[colorIndex],
                    ),
                    child: Center(
                        child: Text(colorIndex.toString(),
                            style: textTheme.headline4!
                                .copyWith(color: colorScheme.onPrimary))),
                  )),
              const Spacer(),
              IconButton(
                icon: const Icon(MdiIcons.backspace),
                onPressed: enteredPassword.isEmpty
                    ? null
                    : () => setState(() => enteredPassword.removeLast()),
              ),
            ],
          ),
        ),
        ...List.generate(
          5,
          (rowIndex) => Expanded(
            child: Row(
              children: List.generate(
                2,
                (columnIndex) {
                  int itemIndex = (rowIndex * 2) + columnIndex;
                  int colorIndex = itemIndex < shuffledNumbers.length
                      ? shuffledNumbers[itemIndex]
                      : 0;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        if (enteredPassword.length < maxPasswordLength) {
                          enteredPassword.add(colorIndex);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                        color: colorOptions[colorIndex],
                        child: Center(
                          child: Text(
                            colorIndex.toString(),
                            style: textTheme.headline4!
                                .copyWith(color: colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ]),
    );
  }
}
