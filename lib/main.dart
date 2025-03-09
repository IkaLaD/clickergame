import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/enemy_view_model.dart';
import 'viewmodels/player_view_model.dart';

import 'views/game_view.dart';

import 'views/home_view.dart';
import 'viewmodels/user_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EnemyViewModel>(create: (context) => EnemyViewModel()),
        ChangeNotifierProvider<PlayerViewModel>(create: (context) => PlayerViewModel()),
      ],
      child: MaterialApp(
        title: 'Clicker Game',
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