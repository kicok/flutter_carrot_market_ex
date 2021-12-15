import 'package:flutter/material.dart';
import 'package:flutter_carror_market_ex/repository/contents_repository.dart';
import 'package:flutter_carror_market_ex/widget/product_body_widget.dart';
import 'package:flutter_svg/svg.dart';

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

  Future<List<dynamic>> _loadContents(currentLocation) {
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: ProductBodyWidget(
        dataList: _loadContents(currentLocation),
      ),
    );
  }
}
