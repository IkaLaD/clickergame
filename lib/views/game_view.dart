import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/core/services/player_service.dart';
import 'package:untitled1/widgets/background/moving_background.dart';
import 'package:untitled1/widgets/shop_widget.dart';

import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';
import '../widgets/enemy_widget.dart';
import '../widgets/player_widget.dart';

class GameView extends StatefulWidget {
  final int playerId;
  const GameView({Key? key, required this.playerId}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  String _bannerText = 'Loading...'; // Initial text
  final PlayerService _apiService = PlayerService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchBannerText(); // Fetch initial text
    _startTimer(); // Start the timer
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchBannerText(); // Fetch new text every 5 seconds
    });
  }

  Future<void> _fetchBannerText() async {
    final leaderboard = await _apiService.fetchLeaderBoard();
    String text = "";
    for (var player in leaderboard){
      text += "${player['pseudo']} : niveau ${player['level']}\n";
    }
    setState(() {
      _bannerText = text; // Update the state with the new text
    });
  }

  @override
  Widget build(BuildContext context) {
    GameViewModel gameViewModel = GameViewModel(
      enemyViewModel: context.read<EnemyViewModel>(),
      playerViewModel: context.read<PlayerViewModel>(),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final bannerWidth = screenWidth / 4;

    return Scaffold(
      body: Stack(
        children: [
          const MovingBackground(),

          // 2. Right-side Banner
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: bannerWidth,
              color: Colors.black.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Leaderboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _bannerText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlayerWidget(
                  viewModel: gameViewModel.playerViewModel,
                  playerId: widget.playerId),
              EnemyWidget(gameViewModel: gameViewModel),
            ],
          ),

          // 5. ShopWidget (Top)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              child: ShopWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
