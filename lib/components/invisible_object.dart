import 'dart:async';

import 'package:flame/components.dart';

import '../maro_game.dart';

class InvisibleObject extends SpriteAnimationGroupComponent
    with HasGameRef<MarioGame> {
  InvisibleObject({required position});
  Vector2 firstPosition = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    firstPosition = Vector2(position.x, position.y);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateObjectMoves(dt);
    super.update(dt);
  }

  void _updateObjectMoves(double dt) {
    if (position.x < 1120 - 650) {
      game.cam.follow(this);
    } else {
      game.cam.stop();
    }

    if (game.player.position.x == game.player.firstPosition.x) {
      position = firstPosition;
    }

    position.x += game.player.velocity.x * dt;
  }
}
