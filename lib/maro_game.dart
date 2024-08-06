import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'components/level.dart';

class MaroGame extends FlameGame {
  final World world = Level(
    levelName: 'level_2',
  );
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() async {
    //load all images and caching from assets/images folder
    await images.loadAllImages();

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
