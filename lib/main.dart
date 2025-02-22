import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewmodels/enemy_view_model.dart';
import 'package:untitled1/views/game_view.dart';
import 'package:untitled1/views/home_view.dart';
import 'core/config/config.dart';
import 'viewmodels/user_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EnemyViewModel()),
      ],
      child: MaterialApp(
        title: 'Battle Game',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const GameView(),
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: MaterialApp(
        title: 'Clicker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}