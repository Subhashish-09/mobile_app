import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen(
      {super.key, required this.courseName, required this.courseId});

  final String courseName;
  final String courseId;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with TickerProviderStateMixin {
  bool _isEnrolled = false;
  bool _isLoaded = false;

  void _getCourseData() async {
    final courseEnrolled = await supabase
        .from("courseEnrolledUsers")
        .select()
        .eq("course_id", widget.courseId)
        .eq("user_id", supabase.auth.currentUser!.id)
        .single()
        .onError((error, stackTrace) => null);

    if (courseEnrolled == null) {
      setState(() {
        _isEnrolled = false;
      });
    } else {
      setState(() {
        _isEnrolled = true;
      });
    }

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCourseData();
  }

  void _goToCourse() async {}

  void _enrollToCourse() async {}

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    return _isLoaded
        ? Scaffold(
            appBar: AppBar(
              flexibleSpace: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    isScrollable: true,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: "Details",
                      ),
                      Tab(
                        text: "Instructors",
                      ),
                      Tab(
                        text: "Content",
                      ),
                      Tab(
                        text: "Reviews",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: Container(
                        width: double.maxFinite,
                        height: 350,
                        margin: const EdgeInsets.only(top: 12),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://prod-discovery.edx-cdn.org/media/course/image/0e575a39-da1e-4e33-bb3b-e96cc6ffc58e-8372a9a276c1.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 320,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 30),
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  children: List.generate(5, (index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                const Text(
                                  "Free",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              children: [
                                Text(
                                  "2 Ratings ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "2 Students",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                "${78} ${widget.courseName}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: Text(
                                "${112} ${widget.courseName}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Text("Instructors"),
                const Text("Content"),
                const Text("Reviews"),
              ],
            ),
            persistentFooterButtons: [
              Row(
                children: [
                  Visibility(
                    visible: !_isEnrolled,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white, // backgroundColor
                        border: Border.all(
                          color: const Color(0xFF878593), // borderColor
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.favorite_border_outlined,
                        color: Color(0xFF878593), // color
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: _isEnrolled ? 0 : 10),
                      width: double.maxFinite,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          _isEnrolled ? _goToCourse() : _enrollToCourse();
                        },
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        child: _isEnrolled
                            ? const Text("Go to Course")
                            : const Text("Enroll to Course"),
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
