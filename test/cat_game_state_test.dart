import 'dart:math';

import 'package:flappy_cat/game/cat_game_state.dart';
import 'package:flappy_cat/game/obstacle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatGameState', () {
    late CatGameState game;

    setUp(() {
      game = CatGameState(random: Random(42));
      game.configure(400, 800);
    });

    test('starts unconfigured game with sane defaults', () {
      expect(game.hasStarted, isFalse);
      expect(game.isGameOver, isFalse);
      expect(game.score, 0);
      expect(game.obstacles, isNotEmpty);
    });

    test('does not update physics before the game has started', () {
      final initialY = game.catY;
      game.update(0.5);
      expect(game.catY, initialY);
    });

    test('gravity pulls the cat downward once started', () {
      game.onTap(); // starts the game and flaps
      final afterFlapY = game.catY;
      final afterFlapVelocity = game.catVelocityY;
      expect(afterFlapVelocity, CatGameState.flapImpulse);

      // Advance enough time for gravity to overcome the flap and start
      // pulling the cat back down.
      for (var i = 0; i < 60; i++) {
        game.update(1 / 60);
      }
      expect(game.catVelocityY, greaterThan(afterFlapVelocity));
      expect(game.catY, isNot(afterFlapY));
    });

    test('flap applies a fixed upward impulse', () {
      game.onTap();
      game.update(0.2);
      game.onTap();
      expect(game.catVelocityY, CatGameState.flapImpulse);
    });

    test('game ends when the cat hits the ground', () {
      game.onTap();
      // Force a large downward velocity and simulate forward until impact.
      game.catVelocityY = 5000;
      for (var i = 0; i < 100 && !game.isGameOver; i++) {
        game.update(1 / 60);
      }
      expect(game.isGameOver, isTrue);
    });

    test('game ends when the cat hits the ceiling', () {
      game.onTap();
      game.catVelocityY = -5000;
      for (var i = 0; i < 100 && !game.isGameOver; i++) {
        game.update(1 / 60);
      }
      expect(game.isGameOver, isTrue);
    });

    test('score increases as obstacles scroll past the cat', () {
      game.onTap();
      final fixedCatY = game.catY;
      // Replace the spawned obstacle with one whose gap spans the whole
      // playfield, so this test isolates scrolling/scoring from collision
      // physics: the cat can never hit it regardless of vertical drift.
      game.obstacles
        ..clear()
        ..add(
          Obstacle(
            x: game.worldWidth,
            gapCenterY: game.worldHeight / 2,
            gapHeight: game.worldHeight,
          ),
        );

      for (var i = 0; i < 600 && game.score == 0; i++) {
        game.update(1 / 60);
        // Hold the cat roughly steady; only the obstacle's position matters.
        game.catY = fixedCatY;
        game.catVelocityY = 0;
      }

      expect(game.isGameOver, isFalse);
      expect(game.score, greaterThan(0));
    });

    test('reset restores initial state after game over', () {
      game.onTap();
      game.catVelocityY = 5000;
      for (var i = 0; i < 100 && !game.isGameOver; i++) {
        game.update(1 / 60);
      }
      expect(game.isGameOver, isTrue);

      game.onTap(); // tap after game-over resets and restarts
      expect(game.isGameOver, isFalse);
      expect(game.score, 0);
      expect(game.hasStarted, isTrue);
    });
  });
}
