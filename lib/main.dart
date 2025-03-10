import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewmodels/shop_view_model.dart';
import 'package:untitled1/core/config/config.dart';
import 'package:untitled1/views/user_view.dart';

import 'viewmodels/enemy_view_model.dart';
import 'viewmodels/player_view_model.dart';
import 'viewmodels/user_viewmodel.dart';

import 'views/game_view.dart';

import 'views/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EnemyViewModel>(create: (context) => EnemyViewModel()),
        ChangeNotifierProvider<PlayerViewModel>(create: (context) => PlayerViewModel()),
        ChangeNotifierProxyProvider<PlayerViewModel, ShopViewModel>(
          create: (context) => ShopViewModel(
            Provider.of<PlayerViewModel>(context, listen: false),
          ),
          update: (context, playerViewModel, previous) =>
          previous!..updateData()
        ),

        ChangeNotifierProvider<UserViewModel>(create: (context) => UserViewModel()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clicker Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CheckLogin(), // Utilisation du widget CheckLogin
      routes: { // Route pour la page du jeu
        '/home': (context) => const HomeView(),
      },
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus(context);
    });
  }

  Future<void> _checkLoginStatus(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.fetchUsers();
    if (userViewModel.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/game');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}