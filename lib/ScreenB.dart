import 'package:flutter/material.dart';

class ScreenB extends StatelessWidget {
  const ScreenB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("계산 결과"),
      centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _returnButton(context), // 수정: 함수 호출 시 context를 전달합니다.
            ],
          )
        ],
      ),
    );
  }

  Widget _returnButton(BuildContext context) { // 수정: context 매개변수 추가
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("돌아 가기"),
        )
      ],
    );
  }
}
