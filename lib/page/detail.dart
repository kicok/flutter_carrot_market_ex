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

  Widget _line() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 15),
    );
  }

  Widget _sizedBox15() {
    return const SizedBox(height: 15);
  }

  Widget _otherSellContents() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          '판매자짐의 판매 상품',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          '모두보기',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _contentsDetail() {
    return Column(
      // CrossAxisAlignment.start로 했지만 왼쪽 정렬이 되지 않고 중앙에 정렬되있어서 전체의 공간을 활용하기 위해 stretch로 사용함
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Text(
          widget.data['title'].toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Text(
          '디지털/가전 ・ 22시간 전',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        _sizedBox15(),
        const Text(
          '선물받은 새 상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
          ),
        ),
        _sizedBox15(),
        const Text(
          '채팅 3 ・ 관심 17 ・ 조회 205',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    // SingleChildScrollView 는 ListView()화 같이 사용할수 없다.
    // 왜냐하면 SingleChildScrollView()와 ListView()에 모두 scroll속성이 들어있기 때문이다
    // 그래서 아래와 같은 CustomScrollView 를 사용하고 SliverList()를 사용하는것이다.
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImage(),
            _sellerSimpleInfo(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _line(),
                  _contentsDetail(),
                  _line(),
                  _otherSellContents(),
                ],
              ),
            ),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            //gridDelegate: 크기와 위치를 제어하는 delegate
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            // delegate : 여러 children을 2차원 배열로 배치하는 sliver를 만든다.
            delegate: SliverChildListDelegate(
              List.generate(20, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 120,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      '상품 제목',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      '금액',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }),
            ),
          ),
        )
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
