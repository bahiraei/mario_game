import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mario_game/components/flag.dart';
import 'package:mario_game/components/player.dart';
import 'package:mario_game/maro_game.dart';

class NextLevel extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MarioGame> {
  NextLevel({
    required Vector2 size,
    required Vector2 position,
  }) : super(
          size: size,
          position: position,
        );

  bool isLevelCompleted = false;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      if (!isLevelCompleted) {
        isLevelCompleted = true;
        game.world.add(
          Flag(
            position: Vector2(
              position.x + 21,
              position.y - 68,
            ),
          ),
        );
      }
    }
    super.onCollision(intersectionPoints, other);
  }
}
