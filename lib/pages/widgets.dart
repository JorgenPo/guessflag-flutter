import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:guessflag/model/game_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ElevatedButton(
          onPressed: callback,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 125, 139)),
          child: AutoSizeText(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white),
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
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OptionButton(options[0].name,
                      onAnswered: results.hasResults() ? null : onAnswered),
                ),
                Expanded(
                  child: OptionButton(options[1].name,
                      onAnswered: results.hasResults() ? null : onAnswered),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OptionButton(options[2].name,
                      onAnswered: results.hasResults() ? null : onAnswered),
                ),
                Expanded(
                  child: OptionButton(options[3].name,
                      onAnswered: results.hasResults() ? null : onAnswered),
                )
              ],
            ),
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
    String text = AppLocalizations.of(context)!.whatCountryFlag;
    Color color = Colors.black;

    if (results.hasResults()) {
      if (results.wasLastAnswerCorrect()) {
        text = AppLocalizations.of(context)!.youAreRight(results.actualAnswer);
        color = Colors.green;
      } else {
        text = AppLocalizations.of(context)!.youAreWrong(results.correctAnswer);
        color = Colors.red;
      }
    }

    return Center(
      child: AutoSizeText(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, color: color),
      ),
    );
  }
}
