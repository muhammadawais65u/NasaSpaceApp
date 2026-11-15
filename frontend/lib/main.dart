import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'services/game_controller.dart';
import 'widgets/ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // The screens are designed wide, like the mock-ups. No effect in a browser.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const JuniorAstronautApp());
}

class JuniorAstronautApp extends StatefulWidget {
  const JuniorAstronautApp({super.key});

  @override
  State<JuniorAstronautApp> createState() => _JuniorAstronautAppState();
}

class _JuniorAstronautAppState extends State<JuniorAstronautApp> {
  final GameController _controller = GameController();

  @override
  void initState() {
    super.initState();
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GameScope(
      controller: _controller,
      child: MaterialApp(
        title: 'Junior Astronaut Mission Trainer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: GameColors.blue, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        home: const AppRoot(),
      ),
    );
  }
}

/// Chooses the first screen from the app state.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    switch (game.phase) {
      case AppPhase.ready:
        return const HomeScreen();
      case AppPhase.error:
        return SpaceBackground(
          maxWidth: 520,
          child: Center(
            child: GlassPanel(
              borderColor: GameColors.red,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded,
                      color: GameColors.yellow, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    game.errorMessage ?? 'Something went wrong.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  GameButton(
                      label: 'Try Again',
                      icon: Icons.refresh,
                      onPressed: game.start),
                ],
              ),
            ),
          ),
        );
      case AppPhase.loading:
        return const SpaceBackground(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: GameColors.yellow),
                SizedBox(height: 16),
                Text(
                  'Mission Control is getting ready...',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        );
    }
  }
}
