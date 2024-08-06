import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'player.dart';

class Level extends World {
  final String levelName;
  late TiledComponent level;

  Level({
    required this.levelName,
  });

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );
    add(level);
    final objectLayer = level.tileMap.getLayer<ObjectGroup>('ActorsLayer')!;
    for (final object in objectLayer.objects) {
      switch (object.class_) {
        case 'Mario':
          final player = Player(
            position: Vector2(
              object.position.x,
              object.position.y,
            ),
          );
          add(player);
      }
    }

    return super.onLoad();
  }
}
