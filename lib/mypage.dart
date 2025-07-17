import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String? userName;
  String? userEmail;
  String? userPhoto;
  String? loginProvider; // 'kakao', 'google', 'apple'

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = userName != null;
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지')),
      body: Center(
        child: isLoggedIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (userPhoto != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(userPhoto!),
                      radius: 40,
                    ),
                  if (userName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        userName!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (userEmail != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        userEmail!,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: logout, child: Text('로그아웃')),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Image.asset('assets/kakao_logo.png', width: 24),
                    label: Text('카카오로 로그인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFEE500),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: kakaoLogin,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Image.asset('assets/google_logo.png', width: 24),
                    label: Text('구글로 로그인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: googleLogin,
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: Icon(Icons.apple, color: Colors.black),
                    label: Text('애플로 로그인'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: appleLogin,
                  ),
                ],
              ),
      ),
    );
  }
}
