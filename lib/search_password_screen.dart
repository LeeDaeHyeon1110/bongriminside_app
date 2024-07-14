import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPasswordScreen extends StatefulWidget {
  @override
  _SearchPasswordScreenState createState() => _SearchPasswordScreenState();
}

class _SearchPasswordScreenState extends State<SearchPasswordScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _securityAnswerController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _studentIdController.addListener(_updateButtonState);
    _securityAnswerController.addListener(_updateButtonState);
    _newPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _studentIdController.text.isNotEmpty &&
          _securityAnswerController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _securityAnswerController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _searchPassword() async {
    final url = Uri.http('3.35.70.96', '/search_pw');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'student_id': _studentIdController.text,
        'security_answer': _securityAnswerController.text,
        'new_password': _newPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('비밀번호 찾기 성공'),
          content: Text('새로운 비밀번호로 변경되었습니다.'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 두 번 팝하여 로그인 화면으로 이동
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('비밀번호 찾기 실패'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(labelText: '학번'),
            ),
            TextField(
              controller: _securityAnswerController,
              decoration: InputDecoration(labelText: '보안 답변'),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: '새 비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _searchPassword : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? Colors.purple : Colors.grey,
              ),
              child: Text('비밀번호 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}
