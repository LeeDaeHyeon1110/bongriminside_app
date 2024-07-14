import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleDetailScreen extends StatefulWidget {
  final String postId;

  ArticleDetailScreen({required Key key, required this.postId}) : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  String _title = '';
  String _content = '';
  String _author = '';
  int _viewCount = 0;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchArticleDetails();
  }

  Future<void> _fetchArticleDetails() async {
    final url = Uri.http('3.35.70.96', '/article', {'post_id': widget.postId});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _title = responseData['title'];
        _content = responseData['content'];
        _author = responseData['author'];
        _viewCount = responseData['view_count'];
        _likeCount = responseData['like_count'];
      });
    } else {
      // Handle error fetching article details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '작성자: $_author',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              '조회수: $_viewCount  좋아요: $_likeCount',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              _content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
