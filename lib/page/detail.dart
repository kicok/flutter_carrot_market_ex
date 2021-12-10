import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carror_market_ex/page/components/manor_temperature_widget.dart';
import 'package:flutter_carror_market_ex/utils/data_utils.dart';
import 'package:flutter_svg/svg.dart';

class DetailContentView extends StatefulWidget {
  final Map<String, String> data;
  const DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  // with SingleTickerProviderStateMixin 이것을 넣지 않으면 AnimationController(vsync: this) 의 vsync에 this값을 할당하지 못한다.
  late Size size;
  late List<Map<String, String>> imgList;
  int _current = 0;
  final ScrollController _controller = ScrollController();
  double scrollPositionToAlpha = 0;

  late AnimationController _animationControlle;

  late Animation _colorTween;

  @override
  void initState() {
    super.initState();

    _animationControlle = AnimationController(vsync: this);
    // with SingleTickerProviderStateMixin 이것을 넣지 않으면 AnimationController(vsync: this) 의 vsync에 this값을 할당하지 못한다.
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationControlle);
    //ColorTween 의 데이터를 _animationController 가 관리 하겠다고 선언을 해준것이라고 보면 된다.

    _controller.addListener(() {
      setState(() {
        scrollPositionToAlpha =
            (_controller.offset > 255) ? 255 : _controller.offset;
        //_controller.offset이 255가 넘으면 255로 고정하고
        //255가 아니면 _controller.offset을 scrollPositionToAlpha 으로 한다.

        _animationControlle.value = scrollPositionToAlpha / 255;
        //_animationController.value는 0부터 1까지
        //_animationController.value 의 값이 0이 되면 _colorTween 의 begin 값인 Colors.white 가 되는 것이고
        //_animationController.value 의 값이 1이 되면 _colorTween 의 end 값인 Colors.black 이 되게 된다.
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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

  Widget _makeAnimatedIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(icon, color: _colorTween.value),
    );
  }

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(
          scrollPositionToAlpha.toInt()), //스크롤 값에 따라서 alpha값이 0~255까지 변동된다.
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: _makeAnimatedIcon(Icons.arrow_back),
      ),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: _makeAnimatedIcon(Icons.share),
        ),
        IconButton(
          onPressed: () {},
          icon: _makeAnimatedIcon(Icons.more_vert),
        ),
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
      controller: _controller,
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print('관심상품 이벤트');
            },
            child: SvgPicture.asset(
              'assets/svg/heart_off.svg',
              width: 25,
              height: 25,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.2),
          ),
          Column(
            children: [
              Text(
                DataUtils.calcStringToWon(
                    DataUtils.stringChange(widget.data['price'])),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Text(
                '가격제안불가',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          // 남아있는 전체 영역을 사용한다.
          Expanded(
            child: Row(
              // Expanded로 남아있는 전체 영역을 사용하게 했지만
              // Row를 사용하면 실제 가로 영역만큼만 사용할수 있음
              // 그러면 MainAxisAlignment.end를 사용할수 있다
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xfff08f4f),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const Text(
                    '채팅으로 거래하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
