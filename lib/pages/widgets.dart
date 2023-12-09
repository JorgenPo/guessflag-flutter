import 'package:flutter/material.dart';
import 'package:guessflag/model/game_model.dart';
import 'package:provider/provider.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final ValueSetter<String>? onAnswered;

  const OptionButton(this.text, {super.key, required this.onAnswered});

  @override
  Widget build(BuildContext context) {
    // We want to button to be disabled if no callback passed
    VoidCallback? callback;

    if (onAnswered != null) {
      callback = () {
        onAnswered!(text);
      };
    }

    return SizedBox(
      child: ElevatedButton(
          onPressed: callback,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 125, 139)),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
    );
  }
}

class Options extends StatelessWidget {
  final List<Country> options;
  final ValueSetter<String> onAnswered;

  const Options({super.key, required this.options, required this.onAnswered});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoundResultsModel>(builder:
        (BuildContext context, RoundResultsModel results, Widget? child) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OptionButton(options[0].name,
                  onAnswered: results.hasResults() ? null : onAnswered),
              OptionButton(options[1].name,
                  onAnswered: results.hasResults() ? null : onAnswered)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OptionButton(options[2].name,
                  onAnswered: results.hasResults() ? null : onAnswered),
              OptionButton(options[3].name,
                  onAnswered: results.hasResults() ? null : onAnswered)
            ],
          )
        ],
      );
    });
  }
}

class CurrentRoundText extends StatelessWidget {
  final RoundResultsModel results;

  const CurrentRoundText({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    String text = "What country flag is that?";
    Color color = Colors.black;

    if (results.hasResults()) {
      if (results.wasLastAnswerCorrect()) {
        text = "You are right! This is indeed ${results.actualAnswer}";
        color = Colors.green;
      } else {
        text = "You are wrong! This is ${results.correctAnswer}";
        color = Colors.red;
      }
    }

    return Text(
      text,
      style: TextStyle(fontSize: 30, color: color),
    );
  }
}
