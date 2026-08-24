import 'dart:math';

import 'obstacle.dart';

/// Pure-Dart game logic for the Flappy Cat game: physics, obstacles,
/// collision detection and scoring. Has no Flutter dependency so it can be
/// unit-tested without a device or renderer.
class CatGameState {
  CatGameState({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const double gravity = 900; // px / s^2
  static const double flapImpulse = -320; // px / s
  static const double scrollSpeed = 160; // px / s
  static const double obstacleSpacing = 220; // px between obstacle spawns
  static const double obstacleWidth = 52; // px
  static const double gapHeight = 170; // px
  static const double catWidth = 48;
  static const double catHeight = 48;
  // Hitbox is intentionally smaller than the drawn sprite for fair collisions.
  static const double hitboxInset = 8;

  double worldWidth = 0;
  double worldHeight = 0;
  double groundY = 0;

  double catX = 0;
  double catY = 0;
  double catVelocityY = 0;

  final List<Obstacle> obstacles = [];
  int score = 0;
  bool isGameOver = false;
  bool hasStarted = false;

  bool get isConfigured => worldWidth > 0 && worldHeight > 0;

  /// Must be called once the play area size is known (and again if it
  /// changes) before [update]/[flap] are used.
  void configure(double width, double height) {
    final wasConfigured = isConfigured;
    worldWidth = width;
    worldHeight = height;
    groundY = height;
    if (!wasConfigured) {
      reset();
    }
  }

  void reset() {
    catX = worldWidth * 0.28;
    catY = worldHeight / 2 - catHeight / 2;
    catVelocityY = 0;
    obstacles
      ..clear()
      ..add(
        Obstacle.random(
          _random,
          x: worldWidth + obstacleWidth,
          gapHeight: gapHeight,
          minGapCenterY: gapHeight,
          maxGapCenterY: groundY - gapHeight,
        ),
      );
    score = 0;
    isGameOver = false;
    hasStarted = false;
  }

  void start() {
    if (!hasStarted && !isGameOver) {
      hasStarted = true;
    }
  }

  /// Handles a tap: starts the game, flaps, or resets after game-over.
  void onTap() {
    if (isGameOver) {
      reset();
      hasStarted = true;
      return;
    }
    if (!hasStarted) {
      hasStarted = true;
    }
    catVelocityY = flapImpulse;
  }

  void update(double dt) {
    if (!hasStarted || isGameOver || !isConfigured) return;

    catVelocityY += gravity * dt;
    catY += catVelocityY * dt;

    for (final obstacle in obstacles) {
      obstacle.x -= scrollSpeed * dt;
    }
    obstacles.removeWhere((o) => o.x + obstacleWidth < 0);

    if (obstacles.isEmpty ||
        obstacles.last.x < worldWidth - obstacleSpacing) {
      obstacles.add(
        Obstacle.random(
          _random,
          x: worldWidth,
          gapHeight: gapHeight,
          minGapCenterY: gapHeight,
          maxGapCenterY: groundY - gapHeight,
        ),
      );
    }

    for (final obstacle in obstacles) {
      if (!obstacle.scored && obstacle.x + obstacleWidth < catX) {
        obstacle.scored = true;
        score++;
      }
    }

    if (_checkCollision()) {
      isGameOver = true;
    }
  }

  bool _checkCollision() {
    if (catY <= 0 || catY + catHeight >= groundY) {
      return true;
    }

    final hitLeft = catX + hitboxInset;
    final hitRight = catX + catWidth - hitboxInset;
    final hitTop = catY + hitboxInset;
    final hitBottom = catY + catHeight - hitboxInset;

    for (final obstacle in obstacles) {
      final overlapsX =
          hitRight > obstacle.x && hitLeft < obstacle.x + obstacleWidth;
      if (!overlapsX) continue;

      final hitsTopPipe = hitTop < obstacle.gapTop;
      final hitsBottomPipe = hitBottom > obstacle.gapBottom;
      if (hitsTopPipe || hitsBottomPipe) {
        return true;
      }
    }
    return false;
  }
}
