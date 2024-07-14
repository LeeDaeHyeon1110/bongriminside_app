import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentScreen extends StatefulWidget {
  final String postId;

  CommentScreen({ required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final url = Uri.http('3.35.70.96', '/comments', {'post_id': widget.postId});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['comments'];
      setState(() {
        _comments = responseData.map((comment) => Map<String, dynamic>.from(comment)).toList();
      });
    } else {
      // Handle error fetching comments
    }
  }

  Future<void> _postComment(String content) async {
    final url = Uri.http('3.35.70.96', '/comment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'post_id': widget.postId, 'content': content}),
    );

    if (response.statusCode == 200) {
      // Successfully posted comment, refresh comments
      _fetchComments();
    } else {
      // Handle error posting comment
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_comments[index]['content']),
                  subtitle: Text(_comments[index]['name']), // Assuming 'name' field in comment data
                  trailing: Text(_comments[index]['datetime']), // Assuming 'datetime' field in comment data
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _postComment(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Handle sending comment
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
