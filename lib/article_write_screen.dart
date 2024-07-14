import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleWriteScreen extends StatefulWidget {
  @override
  _ArticleWriteScreenState createState() => _ArticleWriteScreenState();
}

class _ArticleWriteScreenState extends State<ArticleWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _categories = ['공지', '질문', '자유'];
  String _selectedCategory = '공지';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateButtonState);
    _contentController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _titleController.text.isNotEmpty &&
          _contentController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _writeArticle() async {
    final url = Uri.http('3.35.70.96', '/article/write');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _categories.indexOf(_selectedCategory),
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('게시글 작성 성공'),
          content: Text('게시글이 성공적으로 작성되었습니다.'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // 글 작성 화면 닫기
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('게시글 작성 실패'),
          content: Text('게시글 작성 중 오류가 발생했습니다.'),
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
        title: Text('게시글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: 5,
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value.toString();
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: '카테고리',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _writeArticle : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isButtonEnabled ? Colors.purple : Colors.grey,
              ),
              child: Text('작성하기'),
            ),
          ],
        ),
      ),
    );
  }
}
