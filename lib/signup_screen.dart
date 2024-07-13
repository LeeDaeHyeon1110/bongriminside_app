import 'package:flutter/material.dart';
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
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _idController.addListener(_updateButtonState);
    _nameController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _securityQuestionController.addListener(_updateButtonState);
    _securityAnswerController.addListener(_updateButtonState);
    _selectedSubjectController.addListener(_updateButtonState);
    _teacherController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _idController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _securityQuestionController.text.isNotEmpty &&
          _securityAnswerController.text.isNotEmpty &&
          _selectedSubjectController.text.isNotEmpty &&
          _teacherController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _securityQuestionController.dispose();
    _securityAnswerController.dispose();
    _selectedSubjectController.dispose();
    _teacherController.dispose();
    super.dispose();
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
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String sessionID = responseData['session_id'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(sessionID: sessionID)),
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
              onPressed: _isButtonEnabled ? _register : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? Colors.purple : Colors.grey,
              ),
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
