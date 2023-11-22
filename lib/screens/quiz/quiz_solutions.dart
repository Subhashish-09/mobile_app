import 'package:flutter/material.dart';
import 'package:mobile_app/components/quiz/quiz_navigation_buttons.dart';
import 'package:mobile_app/components/quiz/quiz_solution_card.dart';
import 'package:mobile_app/components/quiz/quiz_subjects_buttons.dart';
import 'package:mobile_app/components/quiz/solution_question_buttons_grid.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';

class QuizSolutions extends StatefulWidget {
  const QuizSolutions(
      {super.key, required this.sessionId, required this.quizId});

  final String sessionId;
  final String quizId;

  @override
  State<QuizSolutions> createState() => _QuizSolutionsPage();
}

class _QuizSolutionsPage extends State<QuizSolutions> {
  int _totalQuestions = 500;
  int _currentQuestion = 1;
  Map _singleQuestionData = {};
  Map _questionResponses = {};
  bool _isLoaded = false;
  String _currentSubject = "";

  bool _isSolutionVisible = false;
  Map<String, List> _questionResponseStatus = {};
  List _questionButtons = [];
  List _quizSubjects = [];

  void statusSheet() async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 350,
            child: SolutionQuestionButtons(
              currentQSubject: _currentSubject,
              questionButtons: _questionButtons,
              changeQuestion: changeQuestion,
              questionStatus: _questionResponseStatus,
            ),
          );
        });
  }

  void changeQuestion(int qNo) async {
    setState(() {
      _currentQuestion = qNo;
    });
    loadSingleQuestion();
    Navigator.pop(context);
  }

  void changeSubject(name, qNo) async {
    setState(() {
      _currentSubject = name;
      _currentQuestion = qNo;
    });
    loadSingleQuestion();
  }

  void loadSingleQuestion() async {
    final question = await supabase
        .from("quizQBank")
        .select()
        .eq("quiz_id", widget.quizId)
        .eq("question_no", _currentQuestion)
        .single();

    final List<dynamic> options = Iterable.generate(question['options_length'])
        .map((e) => e + 1)
        .map((e) => question["option_$e"])
        .toList();

    final int attemptedAnswer = _questionResponses[_currentQuestion.toString()];

    setState(() {
      _singleQuestionData = {
        "question": {
          "questionNo": question['question_no'],
          "question": question['question'],
          "options": options,
        },
        "correctAnswer": question['correct_option']['correct'],
        "attemptedAnswer": attemptedAnswer,
        "questionResponse": attemptedAnswer == 0
            ? "Unattempted"
            : question['correct_option']['correct'] == attemptedAnswer
                ? "Correct"
                : "Incorrect",
        "questionSolution": question['question_solution'] ??
            question["option_${question['correct_option']['correct']}"]
      };
      _currentSubject = question["question_sub_category"];
    });
  }

  void loadQuizSolutions() async {
    final quiz = await supabase
        .from("quiz")
        .select()
        .eq("quiz_id", widget.quizId)
        .single();

    final questionButtons = await supabase
        .from("quizQBank")
        .select('question_no, question_sub_category, quiz_id')
        .eq("quiz_id", widget.quizId)
        .order("question_no", ascending: true);

    final quizSolutions = await supabase
        .from("quizSession")
        .select()
        .eq("quiz_id", widget.quizId)
        .eq("session_id", widget.sessionId)
        .single();

    setState(() {
      _totalQuestions = quiz['quiz_total_questions'];
      _questionResponseStatus = {
        "correct": quizSolutions['session_correct_questions'],
        "incorrect": quizSolutions['session_incorrect_questions'],
        "unattempted": quizSolutions['session_unattempted_questions'],
      };
      _questionButtons = questionButtons;
      _questionResponses = quizSolutions['session_questions_responses'];
      _quizSubjects = quiz['quiz_subjects'];
    });

    loadSingleQuestion();

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    loadQuizSolutions();
    super.initState();
  }

  void previousHandler() async {
    setState(() {
      _currentQuestion = _currentQuestion == 1 ? 1 : _currentQuestion -= 1;
    });
    loadSingleQuestion();
  }

  void nextHandler() async {
    setState(() {
      _currentQuestion =
          _currentQuestion == _totalQuestions ? 1 : _currentQuestion += 1;
    });
    loadSingleQuestion();
  }

  void loadSolution() {
    setState(() {
      if (_isSolutionVisible == true) {
        _isSolutionVisible = false;
      } else {
        _isSolutionVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Solutions"),
              actions: [
                Flexible(
                  child: TextButton(
                    onPressed: statusSheet,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_currentSubject),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.arrow_drop_down_circle_sharp),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    QuizSubjectButtons(
                      quizSubjects: _quizSubjects,
                      changeSubject: changeSubject,
                      currentSubject: _currentSubject,
                    ),
                    QuizSolutionCard(
                      loadSolution: loadSolution,
                      isSolutionLoaded: _isSolutionVisible,
                      questionNo: _singleQuestionData['question']['questionNo'],
                      question: _singleQuestionData['question']['question'],
                      attemptedAnswer: _singleQuestionData['attemptedAnswer'],
                      correctAnswer: _singleQuestionData['correctAnswer'],
                      options: _singleQuestionData['question']['options'],
                      solution: _singleQuestionData['questionSolution'],
                      responseType: _singleQuestionData['questionResponse'],
                    ),
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              QuizNavigationButtons(
                nextHandleName: "Next",
                nextHandler: nextHandler,
                previousHandler: previousHandler,
              ),
            ],
          )
        : const LoadingSpinner();
  }
}
