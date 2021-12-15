import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carror_market_ex/page/detail.dart';
import 'package:flutter_carror_market_ex/utils/data_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductBodyWidget extends StatelessWidget {
  final Future<List<dynamic>> dataList;
  const ProductBodyWidget({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataList,
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

        List<dynamic> datas = snapshot.data;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: datas.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailContentView(data: datas[index]);
                }));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: datas[index]['cid'].toString(),
                        child: Image.asset(
                          datas[index]['image'].toString(),
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DataUtils.stringChange(datas[index]['title']),
                              overflow: TextOverflow.ellipsis, // ... 표기
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              DataUtils.stringChange(datas[index]['location']),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                            Text(
                              DataUtils.calcStringToWon(DataUtils.stringChange(
                                  datas[index]['price'])),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
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
                                Text(DataUtils.stringChange(
                                    datas[index]['likes'])),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
}
