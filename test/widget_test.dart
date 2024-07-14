import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_bongrim_inside/main.dart';
import 'package:flutter_bongrim_inside/home_screen.dart';
import 'package:flutter_bongrim_inside/profile_screen.dart';
import 'package:flutter_bongrim_inside/signup_screen.dart';
import 'package:flutter_bongrim_inside/subject_room.dart';
import 'package:flutter_bongrim_inside/post_screen.dart';
import 'package:flutter_bongrim_inside/comment_screen.dart';

// 수정된 MyApp 테스트 코드
void main() {
  testWidgets('HomeScreen has a bottom navigation bar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the bottom navigation bar is present.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('프로필'), findsOneWidget);
  });

  testWidgets('ProfileScreen displays user info', (WidgetTester tester) async {
    // Build the ProfileScreen widget.
    await tester.pumpWidget(MaterialApp(home: ProfileScreen()));

    // Verify that the profile screen shows the user information.
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text('3719 표강준'), findsOneWidget);
    expect(find.text('선택과목: ~'), findsOneWidget);
  });

  testWidgets('SignupScreen form validation and navigation', (WidgetTester tester) async {
    // Build the SignupScreen widget.
    await tester.pumpWidget(MaterialApp(home: SignupScreen()));

    // Check that the Signup button is disabled initially.
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Enter text into the text fields.
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.pump();

    // Check that the Signup button is enabled after entering text.
    final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(elevatedButton.onPressed != null, isTrue);

    // Tap the Signup button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Check that the navigation to HomeScreen occurs.
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('SubjectRoom shows a list of posts and navigates to PostScreen', (WidgetTester tester) async {
    // Build the SubjectRoom widget.
    await tester.pumpWidget(MaterialApp(home: SubjectRoom()));

    // Verify that the SubjectRoom displays the list of posts.
    expect(find.byType(ListTile), findsNWidgets(10));  // There are 10 items in the ListView.builder

    // Tap on the first post item.
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Verify that the PostScreen is displayed.
    expect(find.byType(PostScreen), findsOneWidget);
  });

  testWidgets('PostScreen shows comments screen on button press', (WidgetTester tester) async {
    // Build the PostScreen widget.
    await tester.pumpWidget(MaterialApp(home: PostScreen()));

    // Tap the floating action button to navigate to CommentScreen.
    await tester.tap(find.byIcon(Icons.comment));
    await tester.pumpAndSettle();

    // Verify that the CommentScreen is displayed.
    expect(find.byType(CommentScreen), findsOneWidget);
  });

  testWidgets('CommentScreen contains a text field and list of comments', (WidgetTester tester) async {
    // Build the CommentScreen widget.
    await tester.pumpWidget(MaterialApp(home: CommentScreen(postId: '',)));

    // Verify that the CommentScreen has a text field and a list of comments.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(10));  // There are 10 items in the ListView.builder
  });
}
