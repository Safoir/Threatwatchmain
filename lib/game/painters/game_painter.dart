import 'package:flutter/material.dart';

import '../cat_game_state.dart';
import '../obstacle.dart';
import '../pixel_art.dart';

/// Renders the current [CatGameState] as pixel-art: sky, obstacles and cat.
class GamePainter extends CustomPainter {
  GamePainter(this.state);

  final CatGameState state;

  static const Color skyTop = Color(0xFF8FD3F4);
  static const Color skyBottom = Color(0xFFCBEFFF);
  static const Color groundColor = Color(0xFF6B4226);

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [skyTop, skyBottom],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    for (final obstacle in state.obstacles) {
      _paintObstacle(canvas, obstacle);
    }

    _paintCat(canvas);

    canvas.drawRect(
      Rect.fromLTWH(0, state.groundY, size.width, 4),
      Paint()..color = groundColor,
    );
  }

  void _paintObstacle(Canvas canvas, Obstacle obstacle) {
    final paint = Paint()..color = obstaclePalette[2];
    final outline = Paint()
      ..color = obstaclePalette[1]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final topRect = Rect.fromLTWH(
      obstacle.x,
      0,
      CatGameState.obstacleWidth,
      obstacle.gapTop,
    );
    final bottomRect = Rect.fromLTWH(
      obstacle.x,
      obstacle.gapBottom,
      CatGameState.obstacleWidth,
      state.groundY - obstacle.gapBottom,
    );

    canvas.drawRect(topRect, paint);
    canvas.drawRect(topRect, outline);
    canvas.drawRect(bottomRect, paint);
    canvas.drawRect(bottomRect, outline);

    const capPixelSize = CatGameState.obstacleWidth / 6;
    paintPixelGrid(
      canvas,
      Offset(obstacle.x, obstacle.gapTop - capPixelSize * 3),
      obstacleCapGrid,
      obstaclePalette,
      capPixelSize,
    );
    paintPixelGrid(
      canvas,
      Offset(obstacle.x, obstacle.gapBottom),
      obstacleCapGrid,
      obstaclePalette,
      capPixelSize,
    );
  }

  void _paintCat(Canvas canvas) {
    final grid = state.catVelocityY < 0 ? catGridFlap : catGridGlide;
    final pixelSize = CatGameState.catWidth / grid.first.length;
    paintPixelGrid(
      canvas,
      Offset(state.catX, state.catY),
      grid,
      catPalette,
      pixelSize,
    );
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}
