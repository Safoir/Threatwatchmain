import 'package:flutter/material.dart';

/// A pixel-art sprite: each cell is an index into a [Color] palette.
/// Index 0 is always transparent.
typedef PixelGrid = List<List<int>>;

const List<Color> catPalette = [
  Colors.transparent, // 0: transparent
  Color(0xFF3B2A22), // 1: outline
  Color(0xFFF2A65A), // 2: fur (orange)
  Color(0xFFFCE7C8), // 3: belly / muzzle (cream)
  Color(0xFF1A1A1A), // 4: eye
  Color(0xFFE98CA6), // 5: ear inner (pink)
];

const List<Color> obstaclePalette = [
  Colors.transparent, // 0: transparent
  Color(0xFF2E5B3E), // 1: outline / dark green
  Color(0xFF57A15B), // 2: main green
  Color(0xFF8A5A34), // 3: pot / cap brown
];

/// Cat with wings/paws tucked, gliding downward.
const PixelGrid catGridGlide = [
  [0, 0, 0, 1, 1, 1, 5, 1, 0, 0, 0, 0],
  [0, 0, 1, 5, 5, 1, 1, 5, 1, 0, 0, 0],
  [0, 0, 1, 2, 2, 2, 2, 2, 1, 0, 0, 0],
  [0, 1, 2, 2, 2, 2, 2, 2, 2, 1, 0, 0],
  [0, 1, 2, 4, 2, 2, 4, 2, 2, 1, 0, 0],
  [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 0],
  [1, 2, 3, 3, 3, 3, 3, 3, 2, 2, 1, 0],
  [1, 2, 2, 3, 3, 3, 3, 3, 2, 2, 2, 1],
  [0, 1, 2, 2, 3, 3, 3, 2, 2, 2, 1, 0],
  [0, 1, 2, 2, 2, 2, 2, 2, 2, 1, 0, 0],
  [0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0],
];

/// Cat mid-flap, paws/tail raised for the upward hop.
const PixelGrid catGridFlap = [
  [0, 0, 0, 1, 1, 1, 5, 1, 0, 0, 0, 0],
  [0, 0, 1, 5, 5, 1, 1, 5, 1, 0, 0, 0],
  [0, 0, 1, 2, 2, 2, 2, 2, 1, 0, 0, 0],
  [0, 1, 2, 2, 2, 2, 2, 2, 2, 1, 0, 1],
  [1, 1, 2, 4, 2, 2, 4, 2, 2, 1, 1, 2],
  [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1],
  [0, 1, 2, 3, 3, 3, 3, 3, 2, 2, 1, 0],
  [0, 1, 2, 2, 3, 3, 3, 2, 2, 2, 1, 0],
  [0, 0, 1, 2, 2, 3, 2, 2, 2, 1, 0, 0],
  [0, 0, 1, 2, 2, 2, 2, 2, 1, 0, 0, 0],
  [0, 0, 0, 1, 1, 2, 1, 1, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
];

/// A small blocky "cap" drawn at the tip of each obstacle pipe.
const PixelGrid obstacleCapGrid = [
  [3, 3, 3, 3, 3, 3],
  [1, 2, 2, 2, 2, 1],
  [1, 2, 2, 2, 2, 1],
];

/// Draws [grid] at [origin], scaling each cell to a [pixelSize] square.
void paintPixelGrid(
  Canvas canvas,
  Offset origin,
  PixelGrid grid,
  List<Color> palette,
  double pixelSize,
) {
  final paint = Paint()..style = PaintingStyle.fill;
  for (var row = 0; row < grid.length; row++) {
    final cols = grid[row];
    for (var col = 0; col < cols.length; col++) {
      final index = cols[col];
      if (index == 0) continue;
      paint.color = palette[index];
      canvas.drawRect(
        Rect.fromLTWH(
          origin.dx + col * pixelSize,
          origin.dy + row * pixelSize,
          pixelSize,
          pixelSize,
        ),
        paint,
      );
    }
  }
}
