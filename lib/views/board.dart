import 'package:flutter/material.dart';

const List<List<int>> board = [
  [00, 01, 02, 00, 00, 16, 17, 18, 00, 28, 29, 30, 00, 43, 44, 45, 46],
  [00, 03, 04, 05, 00, 19, 20, 21, 00, 31, 29, 30, 00, 43, 44, 45, 50],
  [06, 07, 08, 09, 00, 22, 23, 00, 00, 34, 29, 30, 00, 43, 44, 45, 54],
  [10, 11, 12, 00, 00, 24, 25, 00, 00, 00, 29, 30, 39, 00, 00, 45, 56],
  [13, 14, 05, 00, 00, 26, 27, 00, 00, 00, 29, 30, 42, 00, 00, 45, 58],
  [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
  [00, 00, 00, 00, 00, 00, 59, 60, 00, 00, 00, 71, 72, 73, 74, 00, 00],
  [00, 00, 00, 00, 00, 00, 61, 62, 00, 00, 00, 75, 76, 77, 78, 00, 00],
  [00, 00, 00, 00, 00, 00, 63, 64, 65, 00, 00, 79, 80, 81, 82, 00, 00],
  [00, 00, 00, 00, 00, 00, 66, 67, 68, 00, 00, 83, 84, 85, 00, 00, 00],
  [00, 00, 00, 00, 00, 00, 00, 69, 70, 00, 00, 00, 00, 00, 00, 00, 00],
];

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 96, 16, 0),
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          11,
          (y) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              17,
              (x) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color:
                          board[y][x] == 0 ? Colors.transparent : Colors.white,
                      alignment: Alignment.center,
                      child: Text(
                        board[y][x] == 0 ? '' : board[y][x].toString(),
                        style: textTheme.subtitle2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
