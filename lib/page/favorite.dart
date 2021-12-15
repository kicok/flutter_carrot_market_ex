import 'package:flutter/material.dart';
import 'package:flutter_carror_market_ex/repository/contents_repository.dart';
import 'package:flutter_carror_market_ex/widget/product_body_widget.dart';

class MyFavoriteContents extends StatefulWidget {
  const MyFavoriteContents({Key? key}) : super(key: key);

  @override
  _MyFavoriteContentsState createState() => _MyFavoriteContentsState();
}

class _MyFavoriteContentsState extends State<MyFavoriteContents> {
  ContentsRepository contentsRepository = ContentsRepository();

  PreferredSizeWidget _appBarWidget() {
    return AppBar(
      title: const Text(
        '관심목록',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Future<List<dynamic>> _loadMyFavoriteContents() async {
    return await contentsRepository.loadFavoriteContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(),
      body: ProductBodyWidget(
        dataList: _loadMyFavoriteContents(),
      ),
    );
  }
}
