import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carror_market_ex/page/components/manor_temperature_widget.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;
  const DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  late Size size;
  late List<Map<String, String>> imgList;
  int _current = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      {'id': '0', 'img': widget.data['image'].toString()},
      {'id': '1', 'img': widget.data['image'].toString()},
      {'id': '2', 'img': widget.data['image'].toString()},
      {'id': '3', 'img': widget.data['image'].toString()},
      {'id': '4', 'img': widget.data['image'].toString()},
    ];
  }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Stack(
      //alignment: Alignment.center, // 중앙정렬
      children: [
        Hero(
          tag: widget.data['cid'].toString(),
          child: CarouselSlider(
              items: imgList.map((map) {
                return Image.asset(
                  map['img'].toString(),
                  width: size.width,
                  // height: size.height / 2,
                  fit: BoxFit.fill,
                );
              }).toList(),
              options: CarouselOptions(
                height: size.width,
                initialPage: 0,
                enableInfiniteScroll: false, // 무한 스크롤 여부
                viewportFraction:
                    1, // 각 carousel 페이지가 차지하는 화면 영역 비율, 기본은 0.8(80%)를 차지함
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              )),
        ),
        // Caraousel 점 이동
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((map) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == int.parse(map['id'].toString())
                        ? Colors.white
                        : Colors.white.withOpacity(0.4)),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(50),
            //   child: Container(
            //     height: 50,
            //     width: 50,
            //     child: Image.asset('assets/images/user.png'),
            //   ),
            // ),
            CircleAvatar(
              radius: 25,
              backgroundImage: Image.asset('assets/images/user.png').image,
              //child: Image.asset('assets/images/user.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '쳇님이',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(widget.data['location'].toString()),
              ],
            ),
          ]),
          ManorTemperature(manorTemp: 36.5),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _makeSliderImage(),
        _sellerSimpleInfo(),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return Container(
      height: 55,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // body를 AppBar 영역 뒤까지 확장한다는 의미
      appBar: _appBarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
