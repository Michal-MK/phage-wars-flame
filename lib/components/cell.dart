import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:phage_wars/phage_wars.dart';

class Cell extends BodyComponent with DragCallbacks {
  int maxElements = 100;
  int elementCount = 0;
  late PositionComponent root;
  TextComponent? text;

  late final Vector2 initialPosition;
  Vector2 size = Vector2(100, 100);

  Cell({Vector2? initialPosition}) {
    this.initialPosition = initialPosition ?? Vector2(200, 200);
  }

  @override
  Future<void> onLoad() {
    root = PositionComponent();
    renderBody = false;
    root.add(SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('cell_outline.png')),
      size: Vector2(100, 100),
      anchor: Anchor.center,
    ));
    var spriteComponent = SpriteComponent(
      sprite: Sprite(Flame.images.fromCache('cell_innards.png')),
      size: Vector2(100, 100),
      anchor: Anchor.center,
    );
    spriteComponent.add(text = TextComponent(text: elementCount.toString())
      ..position = Vector2(50, 50)
      ..anchor = Anchor.center);
    root.add(spriteComponent);
    add(root);

    return super.onLoad();
  }

  static const double growthRate = 0.2;
  double currentGrowth = 0;
  @override
  void update(double dt) {
    if (elementCount >= maxElements) {
      return;
    }
    currentGrowth += dt;
    if (currentGrowth >= growthRate) {
      currentGrowth = 0;
      elementCount++;
      text!.text = elementCount.toString();
      updateBodySize(body, (size.x / 2) * (1 + elementCount / 100));
    }
    super.update(dt);
  }

  Vector2? offset;
  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    offset = event.parentPosition! - position;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    body.setTransform((event.parentPosition ?? event.canvasPosition) - offset!, 0);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    offset = null;
    body.setAwake(true);
  }

  @override
  Body createBody() {
    return world.createBody(BodyDef(type: BodyType.dynamic, position: initialPosition, gravityScale: Vector2.zero()))
      ..createFixture(FixtureDef(
        CircleShape()..radius = size.x / 2,
      ));
  }

  void updateBodySize(Body body, double newR) {
    // Remove all fixtures from the body
    for (int i = body.fixtures.length - 1; i >= 0; i--) {
      body.destroyFixture(body.fixtures[i]);
    }

    // Create a new shape with the desired size
    final shape = CircleShape();
    shape.radius = newR;

    root.scale = Vector2.all(newR / (size.x / 2));

    // Create a new fixture definition
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.3;

    // Add the fixture to the body
    body.createFixture(fixtureDef);
  }
}
