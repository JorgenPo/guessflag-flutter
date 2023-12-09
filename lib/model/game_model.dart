import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class Country {
  final String name;
  final String code; // two-letter country code

  Country({required this.name, required this.code});
  Country.fromJson(Map<String, dynamic> raw)
      : name = raw["name"] as String,
        code = (raw["alpha-2"] as String).toLowerCase();
}

class GameModel extends ChangeNotifier {
  final List<Country> _countries = [];
  List<Country> countryOptions = [];
  int answerIndex = 0;
  final Random _randomGenerator = Random();
  RoundResultsModel roundResultsModel = RoundResultsModel();
  StatisticsModel? statisticsModel;
  GameState state = GameState();

  Future<void> initialize() async {
    print("Loading countries");

    final countriesJsonString =
        await rootBundle.loadString("assets/countries.json");
    final countriesJson = jsonDecode(countriesJsonString) as List<dynamic>;

    for (final countryJson in countriesJson) {
      _countries.add(Country.fromJson(countryJson as Map<String, dynamic>));
    }

    print("${_countries.length} countries loaded");

    statisticsModel = StatisticsModel(_countries.length);

    await _restoreState();
    _nextQuestion();
  }

  void _nextQuestion() {
    roundResultsModel.reset();
    countryOptions = [];

    if (isFinished()) {
      print("Game over!");
      state.gameOver();
      return;
    }

    _countries.shuffle();

    var nextCountryToGuess = _getNextCountryToGuess();

    // Exclude the country to guess
    var options = List<Country>.from(_countries);
    options.removeWhere((element) => element == nextCountryToGuess);

    countryOptions.add(nextCountryToGuess!);
    countryOptions.add(options[1]);
    countryOptions.add(options[2]);
    countryOptions.add(options[3]);

    countryOptions.shuffle();
    answerIndex = countryOptions.indexOf(nextCountryToGuess);
  }

  Country? _getNextCountryToGuess() {
    for (final country in _countries) {
      if (!statisticsModel!.correctAnswers.contains(country.name)) {
        return country;
      }
    }

    return null;
  }

  Country getAnswer() {
    return countryOptions[answerIndex];
  }

  void submitAnswer(String answer) {
    roundResultsModel.setResults(answer, countryOptions[answerIndex].name);

    final isCorrect = roundResultsModel.wasLastAnswerCorrect();
    statisticsModel!.addAnswer(answer, isCorrect);

    _saveState();

    Future.delayed(const Duration(seconds: 3), () async {
      _nextQuestion();
      notifyListeners();
    });
  }

  Future<File> get _stateFile async {
    final appDirectory = await getApplicationDocumentsDirectory();
    return File("${appDirectory.path}/state.json");
  }

  bool isFinished() {
    return _countries.length <= statisticsModel!.correctAnswers.length;
  }

  void _saveState() async {
    print("Saving game state");

    final stateFile = await _stateFile;

    var state = {'statistics': statisticsModel!.asMap()};

    var serializedState = jsonEncode(state);
    await stateFile.writeAsString(serializedState);
    print("Game state saved!");
  }

  Future<void> _restoreState() async {
    final stateFile = await _stateFile;

    if (!await stateFile.exists()) {
      print("No saved state found");
      return;
    }

    print("Restoring the saved state");

    final stateJson = await stateFile.readAsString();
    final stateObject = jsonDecode(stateJson) as Map<String, dynamic>;

    statisticsModel = StatisticsModel.fromJson(
        stateObject['statistics'] as Map<String, dynamic>);
  }

  void resetProgress() {
    statisticsModel!.reset(_countries.length);
    _saveState();
    _nextQuestion();

    state.reset();
  }
}

class GameState extends ChangeNotifier {
  bool isGameOver = false;

  void gameOver() {
    isGameOver = true;
    notifyListeners();
  }

  void reset() {
    isGameOver = false;
    notifyListeners();
  }
}

class StatisticsModel extends ChangeNotifier {
  final int numberOfCountries;

  List<String> correctAnswers = [];
  List<String> wrongAnswers = [];

  StatisticsModel(this.numberOfCountries);
  StatisticsModel.fromJson(Map<String, dynamic> json)
      : numberOfCountries = json['numberOfCountries'] as int {
    final correctAnswersList = json['correctAnswers'] as List<dynamic>;
    final wrongAnswersList = json['wrongAnswers'] as List<dynamic>;

    correctAnswers = List<String>.from(correctAnswersList);
    wrongAnswers = List<String>.from(wrongAnswersList);
  }

  void reset(int numberOfCountries) {
    correctAnswers = [];
    wrongAnswers = [];
    numberOfCountries = numberOfCountries;
    notifyListeners();
  }

  void addAnswer(String answer, bool isCorrect) {
    isCorrect ? correctAnswers.add(answer) : wrongAnswers.add(answer);
    notifyListeners();
  }

  int getCorrectPercentage() {
    if (correctAnswers.isEmpty && wrongAnswers.isEmpty) {
      return 100;
    }

    return (100 *
            correctAnswers.length /
            (correctAnswers.length + wrongAnswers.length))
        .floor();
  }

  Map<String, dynamic> asMap() {
    return {
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'numberOfCountries': numberOfCountries
    };
  }
}

class RoundResultsModel extends ChangeNotifier {
  String actualAnswer = "";
  String correctAnswer = "";

  void setResults(String actualAnswer, String correctAnswer) {
    print("Set round results actual=$actualAnswer correct=$correctAnswer");

    this.actualAnswer = actualAnswer;
    this.correctAnswer = correctAnswer;
    notifyListeners();
  }

  void reset() {
    print("Reset round results");

    actualAnswer = "";
    correctAnswer = "";
    notifyListeners();
  }

  bool hasResults() {
    return actualAnswer != "";
  }

  bool wasLastAnswerCorrect() {
    return actualAnswer == correctAnswer;
  }
}
