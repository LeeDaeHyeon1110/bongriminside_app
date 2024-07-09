import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      // 로컬화 및 다국어 지원을 위해 로케일 설정을 추가할 수 있습니다.
      // locale: Locale('ko', 'KR'),
      // supportedLocales: [
      //   const Locale('en', 'US'), // 영어
      //   const Locale('ko', 'KR'), // 한국어
      // ],
    );
  }
}

