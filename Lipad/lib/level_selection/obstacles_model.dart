import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class AsteroidData {
  final Size size;
  Alignment alignment;
  late final String path;

  AsteroidData({required this.alignment, required this.size}) {
    List<String> obstaclesPath = [
      "assets/images/maya.png",
      "assets/images/buko.png",
      "assets/images/bangus.png",
      "assets/images/sarimanok.png",
      "assets/images/tsinelas.png",
      "assets/images/jeep.png",
    ];

    // Generate a random index to select a path from the list
    int randomIndex = Random().nextInt(obstaclesPath.length);

    // Assign the randomly selected path
    path = obstaclesPath[randomIndex];
  }
}
