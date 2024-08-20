import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import '../maro_game.dart';

class CollectedItem extends SpriteAnimationComponent
    with HasGameRef<MarioGame>, CollisionCallbacks {
  final String name;

  CollectedItem({
    required Vector2 position,
    required this.name,
  }) : super(
          position: position,
        );

  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    priority = 0;
    add(
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Vector2(16, 16),
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'sprites/$name.png',
      ),
      SpriteAnimationData.sequenced(
        amount: name == 'coin' ? 4 : 1,
        stepTime: .2,
        textureSize: Vector2.all(16),
      ),
    );
    return super.onLoad();
  }

  collisionWithPlayer() {
    if (!collected) {
      FlameAudio.play('coin.wav');
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('sprites/spark.png'),
        SpriteAnimationData.sequenced(
          amount: 9,
          stepTime: .1,
          textureSize: Vector2.all(16),
          loop: false,
        ),
      );
    }
    collected = true;
    Future.delayed(const Duration(milliseconds: 900), () {
      removeFromParent();
    });
  }
}
