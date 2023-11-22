import 'package:flutter/material.dart';
import 'package:mobile_app/components/practise/question.dart';
import 'package:mobile_app/components/practise/option.dart';
import 'package:mobile_app/components/practise/solution.dart';
import 'package:mobile_app/components/practise/navigation.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/practise/questions.dart';

class PractisePage extends StatefulWidget {
  const PractisePage({super.key, required this.practiseId});

  final String practiseId;

  @override
  State<PractisePage> createState() => _PractisePageState();
}

class _PractisePageState extends State<PractisePage> {
  Map<int, int> _userResponses = {};
  int _activeQuestionNo = 0;
  int _attemptedOption = 0;
  bool _isCorrect = false;
  bool _isAttempted = false;
  List<PractiseQuestions> _allQuestions = [];
  PractiseQuestions? _activeQuestion;

  void previousQuestion() {
    if (_activeQuestionNo == 0) {
      return;
    }

    setState(() {
      _activeQuestionNo -= 1;
      _activeQuestion = _allQuestions[_activeQuestionNo];
      _isCorrect = _userResponses[_activeQuestionNo] ==
          _activeQuestion!.correctOption['correct'];
      _isAttempted = _userResponses[_activeQuestionNo] == 0 ? false : true;
      _attemptedOption = _userResponses[_activeQuestionNo] as int;
    });
  }

  void nextQuestion() {
    if (_activeQuestionNo == 24) {
      return setState(() {
        _activeQuestionNo = 0;
        _activeQuestion = _allQuestions[_activeQuestionNo];
        _isCorrect = _userResponses[_activeQuestionNo] ==
            _activeQuestion!.correctOption['correct'];
        _isAttempted = _userResponses[_activeQuestionNo] == 0 ? false : true;
        _attemptedOption = _userResponses[_activeQuestionNo] as int;
      });
    }

    setState(() {
      _activeQuestionNo += 1;
      _activeQuestion = _allQuestions[_activeQuestionNo];
      _isCorrect = _userResponses[_activeQuestionNo] ==
          _activeQuestion!.correctOption['correct'];
      _isAttempted = _userResponses[_activeQuestionNo] == 0 ? false : true;
      _attemptedOption = _userResponses[_activeQuestionNo] as int;
    });
  }

  void optionHandler(index) {
    if (_isAttempted == true) {
      return;
    }

    setState(() {
      _attemptedOption = index;
      _attemptedOption += 1;
      _isAttempted = true;
    });

    if (_attemptedOption == _activeQuestion!.correctOption['correct']) {
      setState(() {
        _isCorrect = true;
      });
    } else {
      setState(() {
        _isCorrect = false;
      });
    }

    updateMap(_activeQuestionNo, index += 1);
  }

  void updateMap(int key, int value) {
    setState(() {
      if (_userResponses.containsKey(key)) {
        if (_userResponses[key] != 0 && _userResponses[key] == value) {
          return;
        }
        _userResponses[key] = value;
      } else {
        _userResponses[key] = value;
      }
    });
  }

  void _loadQuestions() async {
    final List<PractiseQuestions> loadedQuestions = [];

    final data = await supabase
        .from("practiseQBank")
        .select("*")
        .eq("practise_id", widget.practiseId)
        .order(
          "question_no",
          ascending: true,
        );

    for (final item in data) {
      final List options = Iterable.generate(item['options_length'])
          .map((e) => e += 1)
          .map((e) => item['option_$e'])
          .toList();
      loadedQuestions.add(
        PractiseQuestions(
          questionNo: item['question_no'],
          questionType: item['question_type'],
          category: item['question_category'],
          subcategory: item['question_sub_category'],
          topic: item['question_topic'],
          question: item['question'],
          options: options,
          correctOption: item['correct_option'],
          solution: item['question_solution'] == "undefined"
              ? item["option_${(item['correct_option'])['correct']}"]
              : item['question_solution'],
          optionsLength: item['options_length'],
        ),
      );
    }

    setState(() {
      _allQuestions = loadedQuestions;
      _activeQuestion = loadedQuestions[_activeQuestionNo];
      _userResponses = Iterable.generate(loadedQuestions.length)
          .fold({}, (map, index) => map..[index] = 0);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const LoadingSpinner();

    if (_allQuestions.isNotEmpty) {
      content = SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Question(
                question: _activeQuestion!.question,
                questionNo: _activeQuestion!.questionNo,
              ),
              const SizedBox(
                height: 25,
              ),
              Options(
                attemptedAnswer: _attemptedOption,
                isAttempted: _isAttempted,
                optionsHandler: optionHandler,
                options: _activeQuestion!.options,
                optionsLength: _activeQuestion!.optionsLength,
                correctAnswer: _activeQuestion!.correctOption['correct'],
              ),
              const SizedBox(
                height: 25,
              ),
              Visibility(
                visible: _isAttempted,
                child: Solution(
                  solution: _activeQuestion!.solution,
                  isCorrect: _isCorrect,
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(right: 10),
            surfaceTintColor: Colors.white,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Finish"),
            ),
          ),
        ],
      ),
      body: content,
      persistentFooterButtons: [
        Navigation(
          nextHandler: nextQuestion,
          previousHandler: previousQuestion,
        ),
      ],
    );
  }
}
