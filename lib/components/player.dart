import 'dart:async';

import 'package:flame/components.dart';
import 'package:mario_game/maro_game.dart';

enum PlayerState {
  walk,
  jump,
  idle,
}

//with HasGameRef<MaroGame> => یک نمونه از کلاس مربوطه رو برای ما ایجاد می کند
class Player extends SpriteAnimationGroupComponent with HasGameRef<MaroGame> {
  late final SpriteAnimation walkingAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation jumpAnimation;

  Player({
    super.position,
  });

  @override
  FutureOr<void> onLoad() {
    loadAllAnimations();
    return super.onLoad();
  }

  void loadAllAnimations() {
    //تعریف انیمیشن فدم زدن
    walkingAnimation = _spriteAnimation(
      state: 'walk',
      amount: 6,
      stepTime: .15,
    );

    jumpAnimation = _spriteAnimation(
      state: 'jump',
      amount: 1,
      stepTime: 1,
    );

    idleAnimation = _spriteAnimation(
      state: 'idle',
      amount: 2,
      stepTime: .5,
    );

    //معرفی انیمیشن ها به کلاس مربوطه
    animations = {
      PlayerState.walk: walkingAnimation,
      PlayerState.idle: idleAnimation,
      PlayerState.jump: jumpAnimation,
    };

    //تنظیم وضعیت فعلی کاراکتر که در چه حالتی شروع به کار کند. اگر قرار نگیرد کاراکتر در صفحه نمایش داده نمی شود.
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation({
    required String state,
    required int amount,
    required double stepTime,
    double textureSize = 32,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
        'sprites/$state.png',
      ),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(textureSize),
      ),
    );
  }
}
