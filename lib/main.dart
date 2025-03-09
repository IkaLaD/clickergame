import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewmodels/shop_view_model.dart';

import 'viewmodels/enemy_view_model.dart';
import 'viewmodels/player_view_model.dart';

import 'views/game_view.dart';


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

