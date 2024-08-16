import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mario_game/components/player_hitbox.dart';
import 'package:mario_game/maro_game.dart';

import 'collected_item.dart';
import 'impediment_block.dart';

enum PlayerState {
  walk,
  jump,
  idle,
}

//with HasGameRef<MaroGame> => یک نمونه از کلاس مربوطه رو برای ما ایجاد می کند
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<MarioGame>, KeyboardHandler, CollisionCallbacks {
  late final SpriteAnimation walkingAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation jumpAnimation;

  double moveSpeed = 100;
  int moveDirection = 0;
  Vector2 velocity = Vector2(0, 0);
  bool isFacingRight = true;
  bool isPlayerJumped = false;
  bool isPlayerOnGround = false;

  List<ImpedimentBlock> impedimentBlocksList = [];
  PlayerHitBox hitBox = PlayerHitBox(
    width: 23,
    height: 31,
    offsetX: 5,
    offsetY: 1,
  );

  Player({
    super.position,
  });

  @override
  bool get debugMode => false;

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(hitBox.offsetX, hitBox.offsetY),
        size: Vector2(hitBox.width, hitBox.height),
      ),
    );
    loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMoves(dt);
    _checkHorizontalCollision();
    _addGravity(dt);
    _checkVerticalCollision();
    super.update(dt);
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

  void _updatePlayerMoves(double dt) {
    if (isPlayerJumped && isPlayerOnGround) {
      const jumpVelocity = -320.0;
      velocity.y = jumpVelocity;
      position.y += velocity.y * dt;

      isPlayerOnGround = false;
      isPlayerJumped = false;
    }

    velocity.x = (moveSpeed * moveDirection);
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x != 0) {
      playerState = PlayerState.walk;
    }
    if (velocity.x < 0 && isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = false;
    } else if (velocity.x > 0 && !isFacingRight) {
      flipHorizontallyAroundCenter();
      isFacingRight = true;
    }

    if (velocity.y != 0 && !isPlayerOnGround) {
      playerState = PlayerState.jump;
    }
    current = playerState;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool isLeftKeyPressed = keysPressed.contains(
          LogicalKeyboardKey.keyA,
        ) ||
        keysPressed.contains(
          LogicalKeyboardKey.arrowLeft,
        );

    final bool isRightKeyPressed = keysPressed.contains(
          LogicalKeyboardKey.keyD,
        ) ||
        keysPressed.contains(
          LogicalKeyboardKey.arrowRight,
        );

    isPlayerJumped = keysPressed.contains(
      LogicalKeyboardKey.space,
    );

    moveDirection = 0;

    moveDirection += isLeftKeyPressed ? -1 : 0;
    moveDirection += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _checkHorizontalCollision() {
    for (ImpedimentBlock block in impedimentBlocksList) {
      if (isCollisionHappen(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = block.x - hitBox.width - hitBox.offsetX;
        }
        if (velocity.x < 0) {
          velocity.x = 0;
          position.x = block.x + hitBox.width + block.width + hitBox.offsetX;
        }
      }
    }
  }

  void _checkVerticalCollision() {
    for (ImpedimentBlock block in impedimentBlocksList) {
      if (isCollisionHappen(this, block)) {
        if (velocity.y > 0) {
          velocity.y = 0;
          position.y = block.y - hitBox.height - hitBox.offsetY;
          isPlayerOnGround = true;
        }

        if (velocity.y < 0) {
          velocity.y = 0;
          position.y = block.y + height;
        }
      }
    }
  }

  bool isCollisionHappen(
    Player player,
    ImpedimentBlock block,
  ) {
    final playerX = player.x + hitBox.offsetX;
    final playerY = player.y + hitBox.offsetY;
    final fixedPlayerX = player.isFacingRight
        ? playerX
        : playerX - hitBox.width - (hitBox.offsetX * 2);
    return (playerY < block.y + block.height &&
        playerY + hitBox.height > block.y &&
        fixedPlayerX < block.x + block.width &&
        fixedPlayerX + hitBox.width > block.x);
  }

  void _addGravity(double dt) {
    const realGravityOnEarth = 9.8;
    velocity.y += realGravityOnEarth;
    // velocity.clamp(min, max);  //limit gravity
    position.y += velocity.y * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollectedItem) {
      other.collisionWithPlayer();
    }

    super.onCollision(intersectionPoints, other);
  }
}
