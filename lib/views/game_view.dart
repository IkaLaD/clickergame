import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/core/services/player_service.dart';
import 'package:untitled1/models/banner_text_notifier.dart';
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
  final PlayerService _apiService = PlayerService();
  Timer? _timer;
  final BannerTextNotifier _bannerTextNotifier = BannerTextNotifier('Loading...');

  @override
  void initState() {
    super.initState();
    _fetchBannerText(); // Fetch initial text
    _startTimer(); // Start the timer
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _bannerTextNotifier.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchBannerText();
    });
  }

  Future<void> _fetchBannerText() async {
    final leaderboard = await _apiService.fetchLeaderBoard();
    String text = "";
    for (int i = 0 ; i < 3 ; i++) {
      final player = leaderboard[i];
      text += "top ${i+1} : ${player['pseudo']} niveau ${player['level']}\n";
    }
    _bannerTextNotifier.updateText(text);
  }

  @override
  Widget build(BuildContext context) {
    GameViewModel gameViewModel = GameViewModel(
      enemyViewModel: context.read<EnemyViewModel>(),
      playerViewModel: context.read<PlayerViewModel>(),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = 100.0; // Fixed height for the banner

    return Scaffold(
      body: Stack(
        children: [
          const MovingBackground(),
          Column(
            children: [
              // 1. Top Banner
              Container(
                height: bannerHeight,
                width: screenWidth,
                color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Leaderboard",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ValueListenableBuilder<String>(
                          valueListenable: _bannerTextNotifier,
                          builder: (context, value, child) {
                            return Text(
                              value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 2. Main Content
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PlayerWidget(
                        viewModel: gameViewModel.playerViewModel,
                        playerId: widget.playerId),
                    EnemyWidget(gameViewModel: gameViewModel),
                  ],
                ),
              ),
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