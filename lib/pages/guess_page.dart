import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guessflag/model/game_model.dart';
import 'package:guessflag/pages/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: body(),
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppLocalizations.of(context)!.randomMode,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<StatisticsModel>(builder:
                (BuildContext context, StatisticsModel stats, Widget? child) {
              return Text(
                AppLocalizations.of(context)!.headerStats(
                  stats.correctAnswers.length, stats.getCorrectPercentage(), stats.numberOfCountries),
                style: const TextStyle(color: Colors.white),
              );
            }))
      ],
      backgroundColor: const Color.fromARGB(255, 69, 90, 100),
      leadingWidth: 130,
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 69, 90, 100),
                        width: 2)),
                child: Consumer<GameModel>(
                  builder:
                      (BuildContext context, GameModel model, Widget? child) {
                    return SvgPicture.asset(
                      "assets/flags/${model.getAnswer().code}.svg",
                      width: 800,
                      height: 500,
                    );
                  },
                ),
              ),
            )),
        Expanded(
          flex: 1,
          child: Center(
            child: Consumer<RoundResultsModel>(
              builder: (BuildContext context, RoundResultsModel value,
                  Widget? child) {
                return CurrentRoundText(results: value);
              },
            ),
          ),
        ),
        // const Spacer(),
        Expanded(flex: 2, child: answerOptions())
      ],
    );
  }

  Widget answerOptions() {
    return Padding(
        padding: const EdgeInsets.all(1),
        // padding: EdgeInsets.only(bottom: 100, left: 50, right: 50),
        child: Consumer<GameModel>(
            builder: (BuildContext context, GameModel model, Widget? child) {
          return Options(
              options: model.countryOptions, onAnswered: model.submitAnswer);
        }));
  }
}
