import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'subject_room.dart';
import 'profile_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  final String sessionID;

  HomeScreen({required this.sessionID});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  String _userID = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final url = Uri.http('3.35.70.96', '/profile');
    final response = await http.get(
      url,
      headers: {
        'Cookie': 'session_id=${widget.sessionID}',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _userID = responseData['user']['name'];
      });
    } else {
      // Error handling, e.g., session expired
      // Redirect to login screen or show error message
      print('Failed to load user information');
    }
  }

  Future<void> _logout() async {
    final url = Uri.http('3.35.70.96', '/logout');
    await http.delete(
      url,
      headers: {
        'Cookie': 'session_id=${widget.sessionID}',
      },
    );
    await storage.delete(key: 'sessionID');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('환영합니다, $_userID 님', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectRoom()),
                );
              },
              child: Text('과목 선택하기'),
            ),
          ],
        ),
      ),
    );
  }
}
