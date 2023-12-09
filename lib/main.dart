import 'package:flutter/material.dart';
import 'package:guessflag/model/game_model.dart';
import 'package:guessflag/pages/game_over_page.dart';
import 'package:guessflag/pages/guess_page.dart';
import 'package:guessflag/pages/splash_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GameModel gameModel = GameModel();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    initGameModel();
  }

  void initGameModel() async {
    await gameModel.initialize();
    _initialized = true;

    // Artificial delay for the splash screen
    Future.delayed(const Duration(seconds: 1), () {
      if (_initialized) {
        setState(() {
          _initialized = true;
        });
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: homeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget homeScreen() {
    if (_initialized) {
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => gameModel),
        ChangeNotifierProvider(
            create: (context) => gameModel.roundResultsModel),
        ChangeNotifierProvider(create: (context) => gameModel.statisticsModel),
        ChangeNotifierProvider(create: (context) => gameModel.state)
      ], child: getCurrentPage());
    } else {
      return const SplashPage();
    }
  }

  Widget getCurrentPage() {
    return Consumer<GameState>(
      builder: (BuildContext context, GameState state, Widget? child) {
        if (state.isGameOver) {
          return GameOverPage();
        } else {
          return GuessPage();
        }
      },
    );
  }
}
