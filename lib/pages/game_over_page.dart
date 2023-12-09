import 'package:flutter/material.dart';
import 'package:guessflag/model/game_model.dart';
import 'package:provider/provider.dart';

class GameOverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Guess a flag")),
        backgroundColor: const Color.fromARGB(255, 69, 90, 100),
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameModel>(
        builder: (BuildContext context, GameModel model, Widget? child) {
          return body(model);
        },
      ),
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
    );
  }

  Widget body(GameModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Game over!",
            style: TextStyle(fontSize: 40),
          ),
          statistics(model),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () => {model.resetProgress()},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 125, 139)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Reset progress and play again",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  Widget statistics(GameModel model) {
    return Text(
        "You guessed all ${model.statisticsModel!.numberOfCountries} countries with ${model.statisticsModel!.getCorrectPercentage()}% correct answers");
  }
}
