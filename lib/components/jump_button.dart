import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../maro_game.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<MarioGame>, TapCallbacks {
  @override
  FutureOr<void> onLoad() {
    priority = 0;
    sprite = Sprite(game.images.fromCache('jump.png'));
    //دریافت عرض صفحه و تعیین موقعیت دکمه
    position = Vector2(game.size.x - 96, game.size.y - 96);
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.isPlayerJumped = true;
    super.onTapDown(event);
  }
}
