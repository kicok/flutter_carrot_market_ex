import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      title: InkWell(
        onTap: () {
          print('click');
        },
        onLongPress: () {
          print('long Pressed!!');
        },
        child: Row(
          children: const [
            Text('아라동'),
            Icon(Icons.arrow_drop_down),
          ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      bottomNavigationBar: Container(),
    );
  }
}
