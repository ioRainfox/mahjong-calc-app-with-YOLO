
import 'package:flutter/material.dart';

import 'Community.dart';

class Guide extends StatelessWidget {
  const Guide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Page"),
        centerTitle: true,
      ),
      // bottomNavigationBar: _BottomBar(context),
    );
  }

  // Widget _BottomBar(BuildContext context) {
  //   return BottomNavigationBar(
  //     items: const <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.library_books),
  //         label: '족보 가이드',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.home),
  //         label: '메인',
  //       ),
  //       BottomNavigationBarItem(
  //         icon: Icon(Icons.people),
  //         label: '커뮤니티',
  //       ),
  //     ],
  //     currentIndex: 0,
  //     selectedItemColor: Colors.orange,// 현재 선택된 아이템 인덱스 설정
  //     onTap: (int index) {
  //       if (index == 1) { // 홈 아이템이 선택되었을 때
  //         Navigator.of(context).popUntil((route) => route.isFirst); // 첫 번째 페이지로 이동
  //       }
  //       if (index == 2) { // 커뮤니티 아이템이 선택되었을 때
  //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => Community()));
  //       }
  //     },
  //   );
  // }
}
