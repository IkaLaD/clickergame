import 'package:flutter/cupertino.dart';

import 'moving_background.dart';

class MovingBackgroundState extends State<MovingBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String firstImage = 'assets/backgrounds/background_cave_1.png';
  String secondImage = 'assets/backgrounds/background_cave_2.png';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (firstImage == 'assets/backgrounds/background_cave_1.png') {
          firstImage = 'assets/backgrounds/background_cave_2.png';
          secondImage = 'assets/backgrounds/background_cave_1.png';
        }
        else {
          firstImage = 'assets/backgrounds/background_cave_1.png';
          secondImage = 'assets/backgrounds/background_cave_2.png';
        }
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double offsetX = -screenWidth * _controller.value;
        return Stack(
          children: [
            Positioned(
              left: offsetX,
              child: Image.asset(
                firstImage,
                fit: BoxFit.cover,
                width: screenWidth,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Positioned(
              left: offsetX + screenWidth,
              child: Image.asset(
                secondImage,
                fit: BoxFit.cover,
                width: screenWidth,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ],
        );
      },
    );
  }
}