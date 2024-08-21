import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../maro_game.dart';

enum State { walk, die }

class Goomba extends SpriteAnimationGroupComponent with HasGameRef<MarioGame> {
  var rightMargin;
  var leftMargin;
  Goomba({
    position,
    size,
    this.rightMargin = 0.0,
    this.leftMargin = 0.0,
  }) : super(
          position: position,
          size: size,
        );
  late final SpriteAnimation _walkAnimation;
  late final SpriteAnimation _dieAnimation;
  var moveSpeed = 20;
  var moveDirection = 1;
  var startRange = 0.0;
  var endRange = 0.0;
  bool isDied = false;
  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2(15, 14),
        position: Vector2(0, 2),
      ),
    );
    startRange = position.x - leftMargin;
    endRange = position.x + rightMargin;
    _walkAnimation = _spriteAnimation(
      state: 'goomba_walk',
      amount: 2,
      stepTime: .25,
    );
    _dieAnimation = _spriteAnimation(
      state: 'goomba_die',
      amount: 1,
      stepTime: .25,
    );

    animations = {
      State.walk: _walkAnimation,
      State.die: _dieAnimation,
    };
    current = State.walk;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isDied) {
      var playerX = game.player.position.x;
      if (!game.player.isFacingRight) {
        playerX = playerX - game.player.width;
      }
      if (playerX < startRange || playerX > endRange) {
        if (position.x > endRange) {
          moveDirection = -1;
        } else if (position.x < startRange) {
          moveDirection = 1;
        }
      } else {
        if (position.x < playerX) {
          moveDirection = 1;
        } else if (position.x > playerX) {
          moveDirection = -1;
        }
      }
      position.x += moveSpeed * dt * moveDirection;
    }

    super.update(dt);
  }

  SpriteAnimation _spriteAnimation({
    required String state,
    required int amount,
    required double stepTime,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('sprites/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(16),
      ),
    );
  }

  void collisionWithPlayer() {
    if (game.player.velocity.y > 0 &&
        game.player.position.y + game.player.height > position.y) {
      isDied = true;
      current = State.die;
      game.player.velocity.y = -200;
      Future.delayed(const Duration(milliseconds: 500), () {
        removeFromParent();
      });
    } /*else {
      game.player.gameOver();
    }*/
  }
}
