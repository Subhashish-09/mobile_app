import 'package:flutter/material.dart';
import 'package:mobile_app/components/quiz/quiz_results_card.dart';
import 'package:mobile_app/helpers/format_date.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/screens/quiz/quiz_solutions.dart';

class QuizResults extends StatefulWidget {
  const QuizResults({super.key, required this.quizId, required this.sessionId});

  final String quizId;
  final String sessionId;

  @override
  State<QuizResults> createState() => _QuizResultsPage();
}

class _QuizResultsPage extends State<QuizResults> {
  String getRankStatus(int rank) {
    if (rank == 1) {
      return "st";
    } else if (rank == 2) {
      return "nd";
    } else if (rank == 3) {
      return "rd";
    } else {
      return "th";
    }
  }

  @override
  void initState() {
    super.initState();
    loadQuizResults();
  }

  Map quizResult = {};
  Map quizDetails = {};
  bool _isLoaded = false;

  void loadQuizResults() async {
    final quizResults = await supabase
        .from("quizSession")
        .select()
        .eq("session_id", widget.sessionId)
        .eq("quiz_id", widget.quizId)
        .eq("is_quiz_submitted", true)
        .single();

    final quizData = await supabase
        .from("quiz")
        .select()
        .eq("quiz_id", widget.quizId)
        .single();

    setState(() {
      quizResult = quizResults;
      quizDetails = quizData;
      _isLoaded = true;
    });
  }

  int sumAll(List list) {
    return list.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${quizDetails['quiz_name']}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Attempted on ${convertTimestampToReadableText(
                          quizResult['created_at'],
                        )}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Overview",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 310,
                    child: GridView.count(
                      shrinkWrap: false,
                      crossAxisCount: 2,
                      childAspectRatio: 1.75,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      children: [
                        QuizResultsCard(
                          title: "Total Marks",
                          bottomText: quizResult['session_grand_total'],
                          color: Colors.black,
                          bottomDescription: "marks",
                        ),
                        QuizResultsCard(
                          title: "Correct",
                          bottomText:
                              sumAll(quizResult['session_correct_marks']),
                          color: Colors.green,
                          bottomDescription: "marks",
                        ),
                        QuizResultsCard(
                          title: "Incorrect",
                          bottomText:
                              sumAll(quizResult['session_incorrect_marks']),
                          color: Colors.red,
                          bottomDescription: "marks",
                        ),
                        QuizResultsCard(
                          title: "Unattempted",
                          bottomText:
                              sumAll(quizResult['session_unattempted_marks']),
                          color: Colors.orange,
                          bottomDescription: "marks",
                        ),
                        QuizResultsCard(
                          title: "Rank",
                          bottomText: quizResult['session_rank'],
                          color: Colors.orange,
                          bottomDescription:
                              "${getRankStatus(quizResult['session_rank'])} rank",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            persistentFooterButtons: [
              Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      width: double.maxFinite,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => QuizSolutions(
                                quizId: widget.quizId,
                                sessionId: widget.sessionId,
                              ),
                            ),
                          );
                        },
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        child: const Text('View Solutions'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        : const LoadingSpinner();
  }
}
