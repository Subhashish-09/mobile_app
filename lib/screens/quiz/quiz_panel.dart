import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/components/practise/question.dart';
import 'package:mobile_app/components/quiz/question_buttons_grid.dart';
import 'package:mobile_app/components/quiz/quiz_navigation_buttons.dart';
import 'package:mobile_app/components/quiz/quiz_subjects_buttons.dart';
import 'package:mobile_app/components/quiz/single_question_options.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/quiz/question.dart';
import 'package:mobile_app/screens/quiz/quiz_results.dart';

class QuizPanelPage extends StatefulWidget {
  const QuizPanelPage({super.key, required this.id});

  final String id;

  @override
  State<QuizPanelPage> createState() => _QuizPanelPageState();
}

class _QuizPanelPageState extends State<QuizPanelPage> {
  String _sessionId = "";
  String _currentQSubject = "";
  List _questionButtons = [];
  List _quizSubjects = [];
  List _questionOptions = [];
  Map _questionStatus = {};
  int _initialQuestionNo = 1;
  int _currentQuestionResponse = 0;
  int _maxQuestionNo = 500;
  QuizQuestion? _quizQuestion;
  bool _isLoaded = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    loadQuizPanel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadQuestion() async {
    final isPresent = await supabase
        .from("quizSession")
        .select(
            "session_questions_responses, session_questions_response_status")
        .eq("session_id", _sessionId)
        .eq("quiz_id", widget.id)
        .eq("userId", supabase.auth.currentUser?.id)
        .single();

    Map<String, dynamic> responses = isPresent["session_questions_responses"];
    Map<String, dynamic> responseStatus =
        isPresent['session_questions_response_status'];

    responses.putIfAbsent(_initialQuestionNo.toString(), () => 0);
    responseStatus.putIfAbsent(_initialQuestionNo.toString(), () => "Visited");

    await supabase.from("quizSession").update({
      "last_seen_question": _initialQuestionNo,
      "session_questions_responses": responses,
      "session_questions_response_status": responseStatus
    }).match({
      'session_id': _sessionId,
      'quiz_id': widget.id,
      "userId": supabase.auth.currentUser?.id,
    });

    final question = await supabase
        .from("quizQBank")
        .select("*")
        .eq("quiz_id", widget.id)
        .eq("question_no", _initialQuestionNo)
        .single();

    setState(() {
      _quizQuestion = QuizQuestion(
        questionNo: question['question_no'],
        question: question['question'],
      );

      _currentQSubject = question['question_sub_category'];
      _currentQuestionResponse = isPresent['session_questions_responses']
          [_initialQuestionNo.toString()];
      _questionOptions = Iterable.generate(question['options_length'])
          .map((e) => e += 1)
          .map((e) => question['option_$e'])
          .toList();
      _questionStatus = isPresent['session_questions_response_status'];
    });
  }

  void setCurrentResponse(response) async {
    setState(() {
      _currentQuestionResponse = response;
    });
  }

  void saveAndNext() async {
    final isPresent = await supabase
        .from("quizSession")
        .select(
            "session_questions_responses, session_questions_response_status")
        .eq("session_id", _sessionId)
        .eq("quiz_id", widget.id)
        .eq("userId", supabase.auth.currentUser?.id)
        .single();

    Map<String, dynamic> responses = isPresent["session_questions_responses"];
    Map<String, dynamic> responseStatus =
        isPresent['session_questions_response_status'];

    responses.update(
      _initialQuestionNo.toString(),
      (value) => _currentQuestionResponse,
      ifAbsent: () {
        responses.putIfAbsent(
            _initialQuestionNo.toString(), () => _currentQuestionResponse);
      },
    );

    responseStatus.update(
      _initialQuestionNo.toString(),
      (value) => _currentQuestionResponse == 0 ? "Visited" : "Attempted",
      ifAbsent: () {
        responses.putIfAbsent(_initialQuestionNo.toString(),
            () => _currentQuestionResponse == 0 ? "Visited" : "Attempted");
      },
    );

    await supabase.from("quizSession").update({
      "last_seen_question": _initialQuestionNo,
      "session_questions_responses": responses,
      "session_questions_response_status": responseStatus
    }).match({
      'session_id': _sessionId,
      'quiz_id': widget.id,
      "userId": supabase.auth.currentUser?.id,
    });

    setState(() {
      _initialQuestionNo =
          _initialQuestionNo == _maxQuestionNo ? 1 : _initialQuestionNo += 1;
      loadQuestion();
    });
  }

  void loadQuizPanel() async {
    final List quizSessions = await supabase
        .from("quizSession")
        .select("*")
        .eq("quiz_id", widget.id)
        .eq("userId", supabase.auth.currentUser?.id)
        .eq("is_quiz_submitted", false)
        .onError((error, stackTrace) => null);

    if (quizSessions.isEmpty) {
      final data = await supabase
          .from("quizSession")
          .insert({
            "quiz_id": widget.id,
            "last_seen_question": _initialQuestionNo,
            "session_questions_responses": {"1": 0},
            "session_questions_response_status": {"1": "Visited"},
            "is_quiz_submitted": false,
          })
          .select()
          .single();

      setState(() {
        _sessionId = data['session_id'];
      });
    } else {
      setState(() {
        _sessionId = quizSessions[0]['session_id'];
      });
    }

    final quizSession = await supabase
        .from("quizSession")
        .select(
          "*",
        )
        .eq("quiz_id", widget.id)
        .eq("userId", supabase.auth.currentUser?.id)
        .eq("session_id", _sessionId)
        .eq("is_quiz_submitted", false)
        .single();

    setState(() {
      _initialQuestionNo = quizSession['last_seen_question'];
      _questionStatus = quizSession['session_questions_response_status'];
      _currentQuestionResponse = quizSession['session_questions_responses']
          [_initialQuestionNo.toString()];
    });

    final quiz = await supabase
        .from("quiz")
        .select("*")
        .eq("quiz_id", widget.id)
        .single();

    final quizQBank = await supabase
        .from("quizQBank")
        .select("*")
        .eq("quiz_id", widget.id)
        .eq("question_no", _initialQuestionNo)
        .single();

    final questionButtons = await supabase
        .from("quizQBank")
        .select('question_no, question_sub_category, quiz_id')
        .eq("quiz_id", widget.id)
        .order("question_no", ascending: true);

    setState(() {
      _quizQuestion = QuizQuestion(
        questionNo: quizQBank['question_no'],
        question: quizQBank['question'],
      );

      _currentQSubject = quizQBank["question_sub_category"];
      _questionButtons = questionButtons;
      _quizSubjects = quiz['quiz_subjects'];
      _questionOptions = Iterable.generate(quizQBank['options_length'])
          .map((e) => e += 1)
          .map((e) => quizQBank['option_$e'])
          .toList();

      _maxQuestionNo = quiz['quiz_total_questions'];
      _isLoaded = true;
    });
  }

  void changeQuestion(qNo) async {
    setState(() {
      _initialQuestionNo = qNo;
    });
    loadQuestion();
    Navigator.pop(context);
  }

  void changeSubject(name, qNo) async {
    setState(() {
      _currentQSubject = name;
      _initialQuestionNo = qNo;
    });
    loadQuestion();
  }

  void previousHandler() async {
    setState(() {
      _initialQuestionNo =
          _initialQuestionNo == 1 ? 1 : _initialQuestionNo -= 1;
      loadQuestion();
    });
  }

  void finishQuiz() async {
    setState(() {
      _isSubmitting = true;
    });

    final isPresent = await supabase
        .from("quizSession")
        .select(
            "session_questions_responses, session_questions_response_status")
        .eq("session_id", _sessionId)
        .eq("quiz_id", widget.id)
        .eq("userId", supabase.auth.currentUser?.id)
        .single();

    final quizDetails =
        await supabase.from("quiz").select().eq("quiz_id", widget.id).single();

    final questionData =
        await supabase.from("quizQBank").select().eq("quiz_id", widget.id);

    Map<String, dynamic> responses = isPresent["session_questions_responses"];
    Map<String, dynamic> responseStatus =
        isPresent['session_questions_response_status'];

    questionData.forEach((element) => {
          responses.putIfAbsent(element['question_no'].toString(), () => 0),
          responseStatus.putIfAbsent(
              element['question_no'].toString(), () => "Un-Seen")
        });

    List correctQuestions = [];
    List incorrectQuestions = [];
    List unattemptedQuestions = [];

    List correctMarks = [0];
    List incorrectMarks = [0];
    List unattemptedMarks = [0];
    List totalMarks = [0];

    for (final item in responses.entries) {
      final quizQBank = await supabase
          .from("quizQBank")
          .select()
          .eq("quiz_id", widget.id)
          .eq("question_no", item.key)
          .single();

      if (quizQBank['question_type'] == "MSA") {
        if (item.value == quizQBank["correct_option"]["correct"]) {
          correctQuestions.add(item.key);
          correctMarks[0] += quizDetails['quiz_correct_points'];
        } else if (item.value == 0) {
          unattemptedQuestions.add(item.key);
          unattemptedMarks[0] += quizDetails['quiz_correct_points'];
        } else if (item.value != quizQBank["correct_option"]["correct"]) {
          incorrectQuestions.add(item.key);
          incorrectMarks[0] -= quizDetails['quiz_incorrect_points'];
        }
      }
    }

    await supabase
        .from("quizSession")
        .update({
          "session_questions_responses": responses,
          "session_questions_response_status": responseStatus,
          "session_correct_questions": correctQuestions,
          "session_incorrect_questions": incorrectQuestions,
          "session_unattempted_questions": unattemptedQuestions,
          "session_correct_marks": correctMarks,
          "session_incorrect_marks": incorrectMarks,
          "session_unattempted_marks": unattemptedMarks,
          "session_total_marks": totalMarks,
          "session_grand_total": totalMarks[0],
          "session_rank": 1,
          "is_quiz_submitted": true,
        })
        .eq("session_id", _sessionId)
        .select();

    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            QuizResults(quizId: widget.id, sessionId: _sessionId),
      ),
    );
  }

  void statusSheet() async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 350,
            child: QuizQuestionButtons(
              currentQSubject: _currentQSubject,
              questionButtons: _questionButtons,
              changeQuestion: changeQuestion,
              questionStatus: _questionStatus,
            ),
          );
        });
  }

  Duration myDuration = const Duration(days: 5);

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final days = strDigits(myDuration.inDays); // <-- SEE HERE
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return _isLoaded
        ? !_isSubmitting
            ? Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    color: Colors.black,
                    child: Text(
                      '$days:$hours:$minutes:$seconds',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                  Text(_currentQSubject),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                      Icons.arrow_drop_down_circle_sharp),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: finishQuiz,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              child: const Text('Finish'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: _isLoaded
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              QuizSubjectButtons(
                                quizSubjects: _quizSubjects,
                                changeSubject: changeSubject,
                                currentSubject: _currentQSubject,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Question(
                                question: _quizQuestion!.question,
                                questionNo: _quizQuestion!.questionNo,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              SingleQuestionOptions(
                                options: _questionOptions,
                                saveHandler: setCurrentResponse,
                                currentQuestionResponse:
                                    _currentQuestionResponse,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const LoadingSpinner(),
                persistentFooterButtons: [
                  QuizNavigationButtons(
                    nextHandleName: "Save & Next",
                    nextHandler: saveAndNext,
                    previousHandler: previousHandler,
                  ),
                ],
              )
            : const Scaffold(
                body: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(radius: 25),
                    Text("Submitting..."),
                  ],
                )),
              )
        : const LoadingSpinner();
  }
}
