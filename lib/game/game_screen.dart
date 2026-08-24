import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'cat_game_state.dart';
import 'painters/game_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final CatGameState _game = CatGameState();
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / Duration.microsecondsPerSecond;
    _lastTick = elapsed;
    if (dt <= 0 || dt > 0.1) return; // ignore first frame / long pauses
    setState(() {
      _game.update(dt);
    });
  }

  void _handleTap() {
    setState(() {
      _game.onTap();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          _game.configure(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: GamePainter(_game)),
                Positioned(
                  top: 48,
                  left: 0,
                  right: 0,
                  child: Text(
                    '${_game.score}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!_game.hasStarted && !_game.isGameOver)
                  const _CenterMessage(title: 'Flappy Cat', subtitle: 'Tap to start'),
                if (_game.isGameOver)
                  _CenterMessage(
                    title: 'Game Over',
                    subtitle: 'Score: ${_game.score}\nTap to restart',
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
