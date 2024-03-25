
import 'package:flutter/material.dart';

void main() {
  runApp(const ScreenB());
}

class ScreenB extends StatefulWidget {
  const ScreenB({Key? key}) : super(key: key);

  @override
  State<ScreenB> createState() => _SecondPageState();
}

class _SecondPageState extends State<ScreenB> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("계산 결과")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _returnButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _returnButton() {
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