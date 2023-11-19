import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:phage_wars/components/cell.dart';

class PhageWars extends Forge2DGame with SingleGameInstance {
  CameraComponent camera = CameraComponent();

  PositionComponent asset = PositionComponent();

  @override
  void onLoad() {
    asset.add(SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('asset.png')),
      size: Vector2(100, 100),
      anchor: Anchor.center,
    ));
    Cell c = Cell();
    asset.position = camera.viewport.size / 2;
    Cell c2 = Cell(initialPosition: Vector2(300, 300));
    asset.position = camera.viewport.size / 2;
    addAll([asset, c, c2, camera]);
  }

  @override
  void update(double dt) {
    asset.angle += dt;
    super.update(dt);
  }
}
