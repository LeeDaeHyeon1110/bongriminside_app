import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post_screen.dart';

class SubjectRoom extends StatefulWidget {
  @override
  _SubjectRoomState createState() => _SubjectRoomState();
}

class _SubjectRoomState extends State<SubjectRoom> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['공지', '질문', '자유'];
  String _selectedFilter = '공지';

  Future<void> _navigateToPostScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostScreen()),
    );
    // 필요한 경우 결과에 따른 처리 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('과목'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '과목 내 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _filters.map((filter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FilterChip(
                  label: Text(filter),
                  selected: _selectedFilter == filter,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  selectedColor: Colors.purple,
                  checkmarkColor: Colors.white,
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 예시를 위해 임의의 수로 설정
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('게시글 제목 $index'),
                  onTap: _navigateToPostScreen,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 새로운 게시글 작성 로직 추가
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
