import 'package:flutter/material.dart';
import 'package:test/screens/login_screen.dart';
import 'package:test/screens/new_user_screen.dart';
import 'package:test/screens/user_detail_screen.dart';
import 'package:test/screens/users_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic App - Users management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/users': (context) => UsersListScreen(),
        '/new-user': (context) => NewUserScreen(),
        '/user-detail': (context) => UserDetailScreen(),
      },
    );
  }
}
