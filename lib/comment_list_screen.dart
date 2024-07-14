import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentListScreen extends StatefulWidget {
  final String postId;

  CommentListScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentListScreenState createState() => _CommentListScreenState();
}

class _CommentListScreenState extends State<CommentListScreen> {
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final url = Uri.http('3.35.70.96', '/comments', {'post_id': widget.postId});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['comments'];
        List<Comment> comments = data.map((e) => Comment.fromJson(e)).toList();

        setState(() {
          _comments = comments;
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글 목록'),
      ),
      body: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_comments[index].content),
            subtitle: Text('작성자: ${_comments[index].name}'),
            trailing: Text(_comments[index].datetime),
          );
        },
      ),
    );
  }
}

class Comment {
  final String name;
  final String content;
  final String datetime;

  Comment({required this.name, required this.content, required this.datetime});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      name: json['name'],
      content: json['content'],
      datetime: json['datetime'],
    );
  }
}
