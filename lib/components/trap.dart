import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mario_game/maro_game.dart';

class Trap extends SpriteAnimationComponent with HasGameRef<MarioGame> {
  final String name;
  final int rightMargin;
  final int leftMargin;

  Trap({
    required this.name,
    required this.leftMargin,
    required this.rightMargin,
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  int moveDirection = 1;
  int moveSpeed = 40;

  double startRange = 0.0;
  double endRange = 0.0;

  @override
  FutureOr<void> onLoad() {
    add(CircleHitbox());
    startRange = position.x - leftMargin;
    endRange = position.x + rightMargin;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'sprites/$name.png',
      ),
      SpriteAnimationData.sequenced(
        amount: name == 'fire' ? 4 : 8,
        stepTime: name == 'fire' ? .08 : .2,
        textureSize: name == 'fire' ? Vector2.all(9) : Vector2.all(16),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.x >= endRange) {
      moveDirection = -1;
    } else if (position.x <= startRange) {
      moveDirection = 1;
    }
    position.x += moveSpeed * dt * moveDirection;
    super.update(dt);
  }
}
