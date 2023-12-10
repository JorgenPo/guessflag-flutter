import 'package:flutter/material.dart';
import 'package:guessflag/model/game_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameOverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(AppLocalizations.of(context)!.guessFlag)),
        backgroundColor: const Color.fromARGB(255, 69, 90, 100),
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameModel>(
        builder: (BuildContext context, GameModel model, Widget? child) {
          return body(context, model);
        },
      ),
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
    );
  }

  Widget body(BuildContext context, GameModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.gameOver,
            style: const TextStyle(fontSize: 40),
          ),
          statistics(context, model),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () => {model.resetProgress()},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 125, 139)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.resetProgressAndPlayAgain,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  Widget statistics(BuildContext context, GameModel model) {
    return Text(
        AppLocalizations.of(context)!.results(
          model.statisticsModel!.getCorrectPercentage(), model.statisticsModel!.numberOfCountries));
  }
}
