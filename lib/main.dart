import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/Community.dart';

import 'ScreenB.dart'; // ScreenB 파일 import 추가
import 'Community.dart'; // AnotherScreen 파일 import 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? tsu = false;
  bool? lo = false;
  bool? li = false;
  final _wind = ['동', '서', '남', '북'];
  String? _selectedwind;
  XFile? _image; //이미지를 담을 변수 선언
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>(); // 네비게이터 컨텍스트 접근 가능

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedwind = _wind[0]; // 초기 선택값 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      navigatorKey: _navigatorKey, // Assigning navigator key
      home: Scaffold(
        appBar: AppBar(title: const Text("마작 계산기")),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 체크박스를 가운데로 정렬
                children: [
                  _check(),
                  const SizedBox(width: 50,),
                  _buildDropdown(),
                ],
              ),
              const SizedBox(height: 30),
              _buildPhotoArea(),
              const SizedBox(height: 20),
              _buildButton(),
              const SizedBox(height: 30),
              _calcButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: _BottomBar(), // 하단 바 추가
      ),
    );
  }

  Widget _check() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('쯔모'),
        Checkbox(value: tsu, onChanged: (value) {
          setState(() {
            tsu = value;
          });
        }),
        const Text('론'),
        Checkbox(
          value: lo,
          onChanged: (value) {
            setState(() {
              lo = value;
            });
          },
        ),
        const Text('리치'),
        Checkbox(
          value: li,
          onChanged: (value) {
            setState(() {
              li = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<String>(
      value: _selectedwind, // 현재 선택된 값
      onChanged: (String? newValue) {
        setState(() {
          _selectedwind = newValue; // 새로운 값으로 업데이트
        });
      },
      items: _wind.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 300,
      height: 300,
      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }

  Widget _calcButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenB()));
          },
          child: const Text("계산 하기"),
        )
      ],
    );

  }

  Widget _BottomBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: '커뮤니티',
        ),
      ],
      onTap: (int index) {
        if (index == 1) { // 커뮤니티 아이템이 선택되었을 때
          _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => Community())); // 새로운 화면 띄우기
        }
      },
    );
  }
}
