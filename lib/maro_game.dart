import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mario_game/components/jump_button.dart';
import 'package:mario_game/components/player.dart';

import 'components/level.dart';

class MarioGame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  final player = Player();

  late final CameraComponent cam;

  late final JoystickComponent joystickComponent;

  final bool onTouchScreen = false;

  @override
  Color backgroundColor() => Colors.white;

  @override
  FutureOr<void> onLoad() async {
    final World world = Level(
      levelName: 'level_1',
      player: player,
    );

    //load all images and caching from assets/images folder
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 368,
      world: world,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    addJoyStickComponents();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    updateJoyStickDirection();

    super.update(dt);
  }

  void addJoyStickComponents() {
    joystickComponent = JoystickComponent(
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('joystick/background.png'),
        ),
      ),
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('joystick/knob.png'),
        ),
      ),
      margin: const EdgeInsets.fromLTRB(32, 0, 0, 32),
    );

    if (onTouchScreen) {
      addAll([
        joystickComponent,
        JumpButton(),
      ]);
    }
  }

  void updateJoyStickDirection() {
    if (!onTouchScreen) {
      return;
    }
    switch (joystickComponent.direction) {
      case JoystickDirection.left:
        player.moveDirection = -1;
        break;
      case JoystickDirection.right:
        player.moveDirection = 1;
        break;
      default:
        player.moveDirection = 0;
    }
  }
}
