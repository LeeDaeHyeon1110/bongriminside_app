import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _securityQuestionController = TextEditingController();
  final TextEditingController _securityAnswerController = TextEditingController();
  final TextEditingController _selectedSubjectController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextField(
              controller: _securityQuestionController,
              decoration: InputDecoration(labelText: '보안 질문'),
            ),
            TextField(
              controller: _securityAnswerController,
              decoration: InputDecoration(labelText: '보안 답변'),
            ),
            TextField(
              controller: _selectedSubjectController,
              decoration: InputDecoration(labelText: '선택한 과목'),
            ),
            TextField(
              controller: _teacherController,
              decoration: InputDecoration(labelText: '선생님'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _register();
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  void _register() async {
    final url = Uri.http('3.35.70.96', '/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ID': _idController.text,
        '이름': _nameController.text,
        'PW': _passwordController.text,
        'security_question': _securityQuestionController.text,
        'security_answer': _securityAnswerController.text,
        '선택한 과목': _selectedSubjectController.text,
        '선생님': _teacherController.text,
      }),
    );

    if (response.statusCode == 201) {
      // 회원가입 성공 시 세션 ID 저장
      final sessionID = response.headers['set-cookie'];
      await storage.write(key: 'sessionID', value: sessionID!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(sessionID: '',)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('회원가입 실패'),
          content: Text('입력 정보를 다시 확인해주세요.'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}
