import 'dart:math';

/// A vertical obstacle with a gap the cat must fly through.
class Obstacle {
  Obstacle({
    required this.x,
    required this.gapCenterY,
    required this.gapHeight,
    this.scored = false,
  });

  double x;
  final double gapCenterY;
  final double gapHeight;
  bool scored;

  double get gapTop => gapCenterY - gapHeight / 2;
  double get gapBottom => gapCenterY + gapHeight / 2;

  /// Creates an obstacle at [x] with a randomly placed gap, kept within
  /// [minGapCenterY]..[maxGapCenterY] so it never spawns off the playfield.
  factory Obstacle.random(
    Random random, {
    required double x,
    required double gapHeight,
    required double minGapCenterY,
    required double maxGapCenterY,
  }) {
    final gapCenterY =
        minGapCenterY + random.nextDouble() * (maxGapCenterY - minGapCenterY);
    return Obstacle(x: x, gapCenterY: gapCenterY, gapHeight: gapHeight);
  }
}
