import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:basic/level_selection/collision_data.dart';
import 'obstacles_model.dart';
import 'collision_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double shipX = -0.90, shipY = 0.0;
  double maxHeight = 0.0;
  double initialPosition = 0.0;
  double time = 0.0;
  double velocity = 1.9;
  double gravity = -4.9;
  bool isGameRunning = false;
  List<AsteroidData> asteroidData = [];
  List<GlobalKey> GlobalKeys = [];
  GlobalKey shipGlobalKey = GlobalKey();
  int score = 0;

  List<AsteroidData> setAstroidData() {
    List<AsteroidData> data = [
      AsteroidData(
        alignment: const Alignment(3.9, 0.7),
        size: const Size(40, 60),
      ),
      AsteroidData(
        alignment: const Alignment(1.8, -0.5),
        size: const Size(80, 100),
      ),
      AsteroidData(
        alignment: const Alignment(3, -0.3),
        size: const Size(40, 60),
      ),
      AsteroidData(
        alignment: const Alignment(2.3, 0.5),
        size: const Size(40, 60),
      ),
    ];
    return data;
  }

  void startGame() {
    resetData();
    isGameRunning = true;
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      time = time + 0.02;
      setState(() {
        maxHeight = velocity * time + gravity * time * time;
        shipY = initialPosition - maxHeight;
        if (isShipColided()) {
          timer.cancel();
          isGameRunning = false;
        }
      });
      moveAsteroid();
    });
  }

  void onJump() {
    setState(() {
      time = 0;
      initialPosition = shipY;
    });
  }

  double generateRandomNumber() {
    Random rand = Random();
    double randomDouble = rand.nextDouble() * (-1.0 - 1.0) + 1.0;

    return randomDouble;
  }

  void moveAsteroid() {
    Alignment asteroid1 = asteroidData[0].alignment;
    Alignment asteroid2 = asteroidData[1].alignment;
    Alignment asteroid3 = asteroidData[2].alignment;
    Alignment asteroid4 = asteroidData[3].alignment;

    if (asteroid1.x > -1.4) {
      asteroidData[0].alignment = Alignment(asteroid1.x - 0.02, asteroid1.y);
    } else {
      asteroidData[0].alignment = Alignment(2, generateRandomNumber());
    }

    if (asteroid2.x > -1.4) {
      asteroidData[1].alignment = Alignment(asteroid2.x - 0.02, asteroid2.y);
    } else {
      asteroidData[1].alignment = Alignment(1.5, generateRandomNumber());
    }

    if (asteroid3.x > -1.4) {
      asteroidData[2].alignment = Alignment(asteroid3.x - 0.02, asteroid3.y);
    } else {
      asteroidData[2].alignment = Alignment(3, generateRandomNumber());
    }

    if (asteroid4.x > -1.4) {
      asteroidData[3].alignment = Alignment(asteroid4.x - 0.02, asteroid4.y);
    } else {
      asteroidData[3].alignment = Alignment(2.2, generateRandomNumber());
    }

    if (asteroid1.x <= 0.021 && asteroid1.x >= 0.001) {
      score++;
    }
    if (asteroid2.x <= 0.021 && asteroid2.x >= 0.001) {
      score++;
    }
    if (asteroid3.x <= 0.021 && asteroid3.x >= 0.001) {
      score++;
    }
    if (asteroid4.x <= 0.021 && asteroid4.x >= 0.001) {
      score++;
    }
  }

  bool isShipColided() {
    if (shipY > 1) {
      return true;
    } else if (shipY < -1) {
      return true;
    } else if (checkCollision()) {
      return true;
    } else {
      return false;
    }
  }

  bool checkCollision() {
    bool isCollided = false;
    RenderBox shipRenderBox =
        shipGlobalKey.currentContext!.findRenderObject() as RenderBox;
    List<CollisionData> collisionData = [];
    for (var element in GlobalKeys) {
      RenderBox renderBox =
          element.currentContext!.findRenderObject() as RenderBox;

      collisionData.add(
        CollisionData(
          sizeOfObject: renderBox.size,
          positionOfBox: renderBox.localToGlobal(Offset.zero),
        ),
      );
    }

    for (var element in collisionData) {
      final shipPosition = shipRenderBox.localToGlobal(Offset.zero);
      final asteroidPosition = element.positionOfBox;
      final asteroidSize = element.sizeOfObject;
      final shipSize = shipRenderBox.size;

      bool _isCollided =
          (shipPosition.dx < asteroidPosition.dx + asteroidSize.width &&
              shipPosition.dx + shipSize.width > asteroidPosition.dx &&
              shipPosition.dy < asteroidPosition.dy + asteroidSize.height &&
              shipPosition.dy + shipSize.height > asteroidPosition.dy);

      if (_isCollided) {
        isCollided = true;
        break;
      } else {
        isCollided = false;
      }
    }

    return isCollided;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asteroidData = setAstroidData();
    initialiseGlobalKeys();
  }

  void initialiseGlobalKeys() {
    for (int i = 0; i < 4; i++) {
      GlobalKeys.add(GlobalKey());
    }
  }

  void resetData() {
    setState(() {
      asteroidData = setAstroidData();
      shipX = -0.90;
      shipY = 0.0;
      maxHeight = 0.0;
      initialPosition = 0.0;
      time = 0.0;
      velocity = 1.9;
      gravity = -4.9;
      isGameRunning = false;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: isGameRunning ? onJump : startGame,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg1.gif",
                ),
                fit: BoxFit.cover),
          ),
          alignment: const Alignment(0, 0),
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(shipX, shipY),
                  child: Container(
                    key: shipGlobalKey,
                    height: 40,
                    width: 80,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/kitee.png",
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: asteroidData[0].alignment,
                  child: Container(
                    key: GlobalKeys[0],
                    height: asteroidData[0].size.height,
                    width: asteroidData[0].size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(asteroidData[0].path),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: asteroidData[1].alignment,
                  child: Container(
                    key: GlobalKeys[1],
                    height: asteroidData[1].size.height,
                    width: asteroidData[1].size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(asteroidData[1].path),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: asteroidData[2].alignment,
                  child: Container(
                    key: GlobalKeys[2],
                    height: asteroidData[2].size.height,
                    width: asteroidData[2].size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(asteroidData[2].path),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: asteroidData[3].alignment,
                  child: Container(
                    key: GlobalKeys[3],
                    height: asteroidData[3].size.height,
                    width: asteroidData[3].size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(asteroidData[3].path),
                      ),
                    ),
                  ),
                ),
                isGameRunning
                    ? const SizedBox()
                    : const Align(
                        alignment: Alignment(0, -0.5),
                        child: Text(
                          "TAP TO PLAY",
                          style: TextStyle(
                            letterSpacing: 2,
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                Align(
                  alignment: Alignment(0, 0.95),
                  child: Text(
                    "Score: $score",
                    style: const TextStyle(
                      letterSpacing: 2,
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
