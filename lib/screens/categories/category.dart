import 'package:flutter/material.dart';
import 'package:mobile_app/components/categories_card.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/models/course/details.dart';
import 'package:mobile_app/models/home/subcategory.dart';

import 'package:mobile_app/models/quiz/details.dart';
import 'package:mobile_app/screens/categories/topic.dart';
import 'package:mobile_app/screens/quiz/quiz_details.dart';
import 'package:mobile_app/main.dart';

class SingleCategory extends StatefulWidget {
  const SingleCategory(
      {super.key, required this.categorySlug, required this.initialIndex});

  final String categorySlug;
  final int initialIndex;

  @override
  State<SingleCategory> createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  List<HomeSubCategory> _allSubcategories = [];
  List<QuizDetails> _allQuizzes = [];

  Map _loadedCategory = {};

  bool _isLoaded = false;

  void _loadData() async {
    List<HomeSubCategory> loadedSubCategories = [];
    List<QuizDetails> loadedQuizzes = [];
    List<CourseDetails> loadedCourses = [];

    final category = await supabase
        .from("category")
        .select()
        .eq("category_seo_slug", widget.categorySlug)
        .single();

    final subcategories = await supabase
        .from("subcategory")
        .select("*")
        .eq("category", widget.categorySlug)
        .eq("sub_category_is_active", true);

    final quiz = await supabase
        .from("quiz")
        .select("*")
        .eq("quiz_category", widget.categorySlug)
        .order("quiz_name", ascending: true)
        .limit(5);

    final course = await supabase
        .from("course")
        .select("*")
        .eq("course_category", widget.categorySlug)
        .order("course_name", ascending: true)
        .limit(4);

    for (final item in subcategories) {
      loadedSubCategories.add(
        HomeSubCategory(
          name: item['sub_category_name'],
          slug: item['sub_category_seo_slug'],
        ),
      );
    }

    for (final item in quiz) {
      loadedQuizzes.add(
        QuizDetails(
          name: item['quiz_name'],
          id: item['quiz_id'],
          totalQuestions: item['quiz_total_questions'],
        ),
      );
    }

    for (final item in course) {
      loadedCourses.add(
        CourseDetails(
          name: item['course_name'],
          courseId: item['course_id'],
        ),
      );
    }

    setState(() {
      _allQuizzes = loadedQuizzes;
      _allSubcategories = loadedSubCategories;
      _loadedCategory = category;
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? DefaultTabController(
            initialIndex: widget.initialIndex,
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(_loadedCategory['category_name']),
                centerTitle: true,
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: "Subjects",
                    ),
                    Tab(
                      text: "Quizzes",
                    ),
                    // Tab(
                    //   text: "Courses",
                    // )
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          for (final item in _allSubcategories)
                            GestureDetector(
                              child: CategoriesCard(
                                cardTitle: item.name,
                                cardDescription: "25 Chapters",
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => TopicPage(
                                      topicSlug: item.slug,
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      )),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        for (final item in _allQuizzes)
                          GestureDetector(
                            child: CategoriesCard(
                              cardTitle: item.name,
                              cardDescription:
                                  "${item.totalQuestions} Questions",
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => QuizDetailsPage(
                                    name: item.name,
                                    id: item.id,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  // SingleChildScrollView(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: Column(
                  //     children: [
                  //       const SizedBox(
                  //         height: 30,
                  //       ),
                  //       for (final item in _allCourses)
                  //         GestureDetector(
                  //           child: CategoriesCard(
                  //             cardTitle: item.name,
                  //             cardDescription: "2 Videos",
                  //           ),
                  //           onTap: () {
                  //             Navigator.of(context).push(
                  //               MaterialPageRoute(
                  //                 builder: (ctx) => CourseDetailsScreen(
                  //                   courseName: item.name,
                  //                   courseId: item.courseId,
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        : const LoadingSpinner();
  }
}
