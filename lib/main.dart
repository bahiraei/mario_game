import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'maro_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final game = MarioGame();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(
    GameWidget(
      game: kDebugMode ? MarioGame() : game,
    ),
  );
}
