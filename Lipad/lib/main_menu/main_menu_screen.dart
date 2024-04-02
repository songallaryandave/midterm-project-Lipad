import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              right: 10,
              child: Image.asset(
                'assets/images/kite1.gif', // Replace with your image path
                width: 250, // Adjust width as needed
                height: 250, // Adjust height as needed
              ),
            ),
            ResponsiveScreen(
              squarishMainArea: Center(
                child: Transform.rotate(
                  angle: -0.1,
                  child: const Text(
                    'Lipad!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Permanent Marker',
                      fontSize: 55,
                      height: 1,
                    ),
                  ),
                ),
              ),
              rectangularMenuArea: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    onPressed: () {
                      audioController.playSfx(SfxType.buttonTap);
                      GoRouter.of(context).go('/play');
                    },
                    child: const Text('Play'),
                  ),
                  _gap,
                  MyButton(
                    onPressed: () => GoRouter.of(context).push('/settings'),
                    child: const Text('Settings'),
                  ),
                  _gap,
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: settingsController.audioOn,
                      builder: (context, audioOn, child) {
                        return IconButton(
                          onPressed: () => settingsController.toggleAudioOn(),
                          icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                        );
                      },
                    ),
                  ),
                  _gap,
                  const Text('Music by: Celeste Legaspi'),
                  _gap,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
