import 'dart:async';

import 'package:flame/components.dart';
import 'package:mario_game/maro_game.dart';

class Flag extends SpriteAnimationComponent with HasGameRef<MarioGame> {
  Flag({
    required Vector2 position,
  }) : super(
          position: position,
        );

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('sprites/flag_up.png'),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: .1,
        textureSize: Vector2.all(16),
        loop: false,
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 800),
      () {
        animation = SpriteAnimation.fromFrameData(
          game.images.fromCache('sprites/flag_wave.png'),
          SpriteAnimationData.sequenced(
            amount: 4,
            stepTime: .1,
            textureSize: Vector2.all(16),
            loop: true,
          ),
        );
      },
    );
    return super.onLoad();
  }
}
