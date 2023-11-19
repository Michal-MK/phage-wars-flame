import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:phage_wars/phage_wars.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.images.loadAll(['asset.png', 'cell_outline.png', 'cell_innards.png']);

  runApp(
    GameWidget(
      game: PhageWars(),
    ),
  );
}
