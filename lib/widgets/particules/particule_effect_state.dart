import 'package:flutter/material.dart';
import 'package:untitled1/widgets/particules/particule_effect.dart';

class ParticuleEffectState extends State<ParticuleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Offset _particles;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _particles = Offset(widget.position.dx - 60, widget.position.dy - 60);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: _particles.dx,
            top: _particles.dy,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Image.asset(
                "assets/particule.png",
                width: 120,
                height: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }

}