import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ManorTemperature extends StatelessWidget {
  final double manorTemp;
  ManorTemperature({Key? key, required this.manorTemp}) : super(key: key) {
    _calcTempLevel();
  }

  int level = 0;
  final List<Color> tempPerColors = const [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  void _calcTempLevel() {
    if (manorTemp <= 20) {
      level = 0;
    } else if (manorTemp > 20 && manorTemp <= 32) {
      level = 1;
    } else if (manorTemp > 32 && manorTemp <= 36.5) {
      level = 2;
    } else if (manorTemp > 36.5 && manorTemp <= 40) {
      level = 3;
    } else if (manorTemp > 40 && manorTemp <= 50) {
      level = 4;
    } else if (manorTemp > 50) {
      level = 5;
    }
  }

  Widget _makeTempleLabelAndBar() {
    double _width = 60;
    return SizedBox(
      width: _width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$manorTemp˚C',
            style: TextStyle(
              color: tempPerColors[level],
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          // 막대그래프
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: (_width / 99) *
                        manorTemp, // 온도 값이 0~99도 까지 맞춰진다는 범위에서 막대그래프의 색이 비율대로 채워짐
                    color: tempPerColors[level],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            _makeTempleLabelAndBar(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: CircleAvatar(
                radius: 15,
                backgroundImage:
                    Image.asset('assets/images/level-$level.jpg').image,
              ),
            )
          ],
        ),
        const Text(
          '매너온도',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 12,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}
