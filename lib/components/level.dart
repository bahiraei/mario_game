import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:mario_game/components/impediment_block.dart';
import 'package:mario_game/components/trap.dart';

import 'collected_item.dart';
import 'invisible_object.dart';
import 'player.dart';

class Level extends World {
  final String levelName;
  final Player player;
  late TiledComponent level;

  List<ImpedimentBlock> impedimentBlocksList = [];

  Level({
    required this.levelName,
    required this.player,
  });

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(
      '$levelName.tmx',
      Vector2.all(16),
    );
    add(level);
    final actorsLayer = level.tileMap.getLayer<ObjectGroup>('ActorsLayer')!;
    for (final actor in actorsLayer.objects) {
      switch (actor.class_) {
        case 'Mario':
          player.position = Vector2(
            actor.position.x,
            actor.position.y,
          );
          add(player);
      }
    }

    final impedimentsLayer =
        level.tileMap.getLayer<ObjectGroup>('ImpedimentsLayer')!;
    for (final impediment in impedimentsLayer.objects) {
      switch (impediment.class_) {
        case 'trap':
          final leftMargin = impediment.name == 'fire'
              ? impediment.properties.getValue('leftMargin')
              : 0;

          final rightMargin = impediment.name == 'fire'
              ? impediment.properties.getValue('rightMargin')
              : 0;
          add(
            Trap(
              name: impediment.name,
              leftMargin: leftMargin,
              rightMargin: rightMargin,
              position: Vector2(
                impediment.x,
                impediment.y,
              ),
              size: Vector2(
                impediment.width,
                impediment.height,
              ),
            ),
          );

        default:
          final bloc = ImpedimentBlock(
            size: Vector2(
              impediment.size.x,
              impediment.size.y,
            ),
            position: Vector2(
              impediment.position.x,
              impediment.position.y,
            ),
          );
          add(bloc);
          impedimentBlocksList.add(bloc);
      }
    }

    player.impedimentBlocksList = impedimentBlocksList;

    final invisibleLayer =
        level.tileMap.getLayer<ObjectGroup>('InvisibleLayer')!;
    for (final invisibleObject in invisibleLayer.objects) {
      switch (invisibleObject.class_) {
        case 'InvisibleObject':
          add(
            InvisibleObject(
              position: Vector2(
                invisibleObject.x,
                invisibleObject.y,
              ),
            ),
          );
      }
    }

    final collectedItemsLayer = level.tileMap.getLayer<ObjectGroup>(
      'CollectedItemsLayer',
    );
    for (final collectedItem in collectedItemsLayer!.objects) {
      switch (collectedItem.class_) {
        case 'CollectedItem':
          add(
            CollectedItem(
              position: Vector2(
                collectedItem.x,
                collectedItem.y,
              ),
              name: collectedItem.name,
            ),
          );
      }
    }

    return super.onLoad();
  }
}
