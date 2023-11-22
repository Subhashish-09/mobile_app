import 'package:flutter/material.dart';
import 'package:mobile_app/components/categories_card.dart';
import 'package:mobile_app/components/quiz/quiz_details_text.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/screens/quiz/quiz_panel.dart';

import 'package:mobile_app/screens/quiz/quiz_results.dart';

class QuizDetailsPage extends StatefulWidget {
  const QuizDetailsPage({super.key, required this.name, required this.id});

  final String name;
  final String id;

  @override
  State<QuizDetailsPage> createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  List quizSessions = [];
  Map quizDetails = {};

  bool _isLoaded = false;

  @override
  void initState() {
    _loadQuizDetails();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadQuizDetails() async {
    String? session = supabase.auth.currentUser?.id;
    final quizSession = await supabase
        .from("quizSession")
        .select()
        .eq("quiz_id", widget.id)
        .eq("userId", session)
        .is_("is_quiz_submitted", true)
        .onError((error, stackTrace) => null);

    final quizData =
        await supabase.from("quiz").select().eq("quiz_id", widget.id).single();

    setState(() {
      quizSessions = quizSession ?? [];
      quizDetails = quizData;
      _isLoaded = true;
    });
  }

  String convertTimeStringToFormatted(String timeString) {
    List<String> timeComponents = timeString.split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);

    // Format the time
    String formattedTime = '${hours}h ${minutes}m';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            appBar: AppBar(
              title: Text(widget.name),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(
                          text: "Info",
                        ),
                        Tab(
                          text: "Attempts",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.755,
                      child: TabBarView(
                        children: [
                          ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Details: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  QuizDetailsText(
                                    text:
                                        "${quizDetails['quiz_total_questions']} Questions",
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                    child: Icon(
                                      Icons.circle,
                                      size: 10,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  QuizDetailsText(
                                    text: convertTimeStringToFormatted(
                                      quizDetails['quiz_total_duration'],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  QuizDetailsText(
                                      text:
                                          "Correct:  + ${quizDetails['quiz_correct_points']}")
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  QuizDetailsText(
                                      text:
                                          "Incorrect: -${quizDetails['quiz_incorrect_points']}")
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  QuizDetailsText(
                                      text:
                                          "Total Score: ${quizDetails['quiz_total_score']}")
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Sections: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              for (final item in quizDetails['quiz_subjects'])
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    QuizDetailsText(
                                      text: item['name'],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Syllabus: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              for (final item in quizDetails['quiz_chapters'])
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    QuizDetailsText(text: item['name']),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          ListView(
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              for (var (index, item) in quizSessions.indexed)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => QuizResults(
                                          quizId: quizDetails['quiz_id'],
                                          sessionId: item['session_id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: CategoriesCard(
                                    cardTitle: "Attempt - ${index + 1}",
                                    cardDescription:
                                        "${item['session_grand_total']} / ${quizDetails['quiz_total_score']} Marks",
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizPanelPage(id: quizDetails['quiz_id']),
                            ),
                          );
                        },
                        style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        child: quizSessions.isEmpty
                            ? const Text("Start Quiz")
                            : const Text("Attempt Again"),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )
        : const LoadingSpinner();
  }
}
