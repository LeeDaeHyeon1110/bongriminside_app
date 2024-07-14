import 'package:flutter/material.dart';
import 'comment_screen.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '[자유] 이게 최종본으로 할게요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                // CircleAvatar(
                //   backgroundImage: AssetImage('assets/profile_image.png'),
                // ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('3719 표강준', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text('2024 07 05 19:10 조회 수: 9', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            Text(
              '네',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CommentScreen(postId: '',)),
          );
        },
        child: Icon(Icons.comment),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
