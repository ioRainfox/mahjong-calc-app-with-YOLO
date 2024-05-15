import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart'; // 카메라 패키지 import
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart'; // file_picker 패키지 import

import 'CameraScreen.dart';
import 'ScreenB.dart'; // ScreenB 파일 import 추가
import 'Community.dart';
import 'Guide.dart';

List<CameraDescription> cameras = []; // 카메라 리스트 초기화

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras(); // 사용 가능한 카메라 목록 가져오기
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
  XFile? _image;
  CameraController? _cameraController; // 카메라 컨트롤러 추가
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedwind = _wind[0];
    });
    _initializeCamera(); // 카메라 초기화 함수 호출
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      cameras[0], // 첫 번째 카메라 선택
      ResolutionPreset.medium, // 해상도 설정
    );
    await _cameraController!.initialize(); // 카메라 초기화
  }

  @override
  void dispose() {
    if (_cameraController != null) {
      _cameraController!.dispose(); // 카메라 컨트롤러 해제
    }
    super.dispose();
  }

  Future<void> _getImageFromCamera() async {
    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        XFile imageFile = await _cameraController!.takePicture(); // 카메라로 사진 촬영
        setState(() {
          _image = imageFile;
        });
      }
    } catch (e) {
      print(e); // 오류 발생 시 오류 메시지 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("마작 계산기"),
          actions: [
            _my()
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _check(),
                  const SizedBox(width: 25,),
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
        bottomNavigationBar: _BottomBar(),
      ),
    );
  }

  Widget _my() {
    return Row(
      children: [
        OutlinedButton(
          onPressed: () {
            _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => Guide()));
          },
          child: const Text('my'),
        )
      ],
    );
  }

  Widget _check() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('쯔모', style: TextStyle(fontSize: 20, color: Colors.black),),
        Checkbox(
          value: tsu,
          onChanged: (value) {
            setState(() {
              tsu = value;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(4),
          ),
          side: const BorderSide(
            color: Colors.orange,
            width: 1,
          ),
          activeColor: Colors.orange,
          checkColor: Colors.white,
        ),

        const Text('론', style: TextStyle(fontSize: 20, color: Colors.black),),
        Checkbox(
          value: lo,
          onChanged: (value) {
            setState(() {
              lo = value;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(4),
          ),
          side: const BorderSide(
            color: Colors.orange,
            width: 1,
          ),
          activeColor: Colors.orange,
          checkColor: Colors.white,
        ),

        const Text('리치', style: TextStyle(fontSize: 20, color: Colors.black),),
        Checkbox(
          value: li,
          onChanged: (value) {
            setState(() {
              li = value;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(4),
          ),
          side: const BorderSide(
            color: Colors.orange,
            width: 1,
          ),
          activeColor: Colors.orange,
          checkColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<String>(
      value: _selectedwind,
      icon: FaIcon(FontAwesomeIcons.angleDown),
      iconSize: 15,
      style: TextStyle(fontSize: 20, color: Colors.black),
      underline: Container(
        height: 0,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedwind = newValue;
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
      child: Image.file(File(_image!.path)),
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
          onPressed: () async {
            if (_cameraController != null && _cameraController!.value.isInitialized) {
              final image = await Navigator.push<XFile>(
                _navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(cameraController: _cameraController!),
                ),
              );
              if (image != null) {
                setState(() {
                  _image = image;
                });
              }
            }
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            _getImageFromGallery(); // 갤러리에서 사진을 가져오는 함수 호출
          },
          child: const Text("갤러리"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _image = null;
              });
            },
            child: const Text("사진 초기화")
        )
      ],
    );
  }


  Future<void> _getImageFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // 모든 파일 선택
        allowMultiple: true, // 다중 선택 활성화
      );
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        // 여러 파일 중 이미지 파일만 필터링
        List<File> imageFiles = files.where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.jpeg') || file.path.endsWith('.png')).toList();
        // 이미지 파일 중 첫 번째 파일 선택
        if (imageFiles.isNotEmpty) {
          setState(() {
            _image = XFile(imageFiles.first.path);
          });
        }
      }
    } catch (e) {
      print(e); // 오류 발생 시 오류 메시지 출력
    }
  }


  Widget _calcButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            if(_image == null) {

            }
            else {
              _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => ScreenB()));
            }
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
          label: '메인',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: '커뮤니티',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.orange,
      onTap: (int index) {
        if (index == 1) {
          _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => Community()));
        }
      },
    );
  }
}