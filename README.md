# Flappy Cat

A simple Flappy-Bird-style mobile game built with Flutter. Tap to make the
cat flap upward, dodge the scrolling obstacles, and rack up points. All art
is pixel-art drawn procedurally in code — no external image assets.

## Running

```
flutter pub get
flutter run
```

## Testing

```
flutter analyze
flutter test
```

## Project structure

- `lib/main.dart` — app entry point
- `lib/game/game_screen.dart` — game loop (Ticker), input handling, UI overlays
- `lib/game/cat_game_state.dart` — pure-Dart physics/collision/scoring logic
- `lib/game/obstacle.dart` — obstacle data model
- `lib/game/pixel_art.dart` — procedural pixel-art sprite grids and renderer
- `lib/game/painters/game_painter.dart` — `CustomPainter` that draws the scene
- `test/cat_game_state_test.dart` — unit tests for the game logic
