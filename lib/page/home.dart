import 'package:flutter/material.dart';
import 'package:flutter_carror_market_ex/repository/contents_repository.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContentsRepository contentsRepository = ContentsRepository();
  String currentLocation = 'ara';
  final Map<String, String> locationTypeToString = {
    'ara': '아라동',
    'ora': '오라동',
    'donam': '도남동',
  };

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print('click');
        },
        onLongPress: () {
          print('long Pressed!!');
        },
        child: PopupMenuButton<String>(
          offset: const Offset(0, 25),
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            1,
          ),
          onSelected: (String where) {
            setState(() => currentLocation = where);
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: 'ara', child: Text('아라동')),
              PopupMenuItem(value: 'ora', child: Text('오라동')),
              PopupMenuItem(value: 'donam', child: Text('도남동')),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation].toString()),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/svg/bell.svg", width: 22),
        ),
      ],
    );
  }

  String _stringChange(dynamic str) {
    if (str == null) return "";
    return str.toString();
  }

  String calcStringToWon(String priceString) {
    final oCcy = NumberFormat();
    if (priceString == '무료나눔') return priceString;
    return oCcy.format(int.parse(priceString)) + "원";
  }

  _loadContents(currentLocation) {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadContents(currentLocation),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('데이터 오류'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('해당 지역에 데이터가 없음'));
        }

        List<Map<String, String>> datas = snapshot.data;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      datas[index]['image'].toString(),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _stringChange(datas[index]['title']),
                            overflow: TextOverflow.ellipsis, // ... 표기
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            _stringChange(datas[index]['location']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          Text(
                            calcStringToWon(
                                _stringChange(datas[index]['price'])),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/heart_off.svg",
                                width: 13,
                                height: 13,
                              ),
                              const SizedBox(width: 5),
                              Text(_stringChange(datas[index]['likes'])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
            // return Container(
            //   height: 1,
            //   color: Colors.black.withOpacity(0.4),
            // );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }
}
