import 'package:flame/components.dart';

class ImpedimentBlock extends PositionComponent {
  ImpedimentBlock({
    required Vector2 size,
    required Vector2 position,
  }) : super(
          size: size,
          position: position,
        );

  @override
  bool get debugMode => false;
}
