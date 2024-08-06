import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:mario_game/level/level.dart';

class MaroGame extends FlameGame {
  final World world = Level();
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 368,
      world: world,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
    return super.onLoad();
  }
}
