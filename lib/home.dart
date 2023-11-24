import 'package:flutter/material.dart';
import 'package:mobile_app/components/categories_card.dart';
import 'package:mobile_app/helpers/auth/sign_out.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/home/category.dart';
import 'package:mobile_app/screens/categories/all_categories.dart';
import 'package:mobile_app/screens/categories/category.dart';
import 'package:mobile_app/screens/categories/subcategory.dart';
import 'package:mobile_app/screens/quiz/quiz_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeCategory> _homeCategories = [];
  List _loadedSubCategories = [];
  List _loadedQuizzes = [];
  bool _isLoaded = false;

  late HomeCategory _selectedCategory;

  void _loadSingleCategory() async {
    final subjects = await supabase
        .from("subcategory")
        .select()
        .eq("category", _selectedCategory.slug)
        .eq("sub_category_is_active", true)
        .limit(3);

    final quizzes = await supabase
        .from("quiz")
        .select()
        .eq("quiz_category", _selectedCategory.slug)
        .eq("quiz_is_active", true)
        .limit(3)
        .order(
          "quiz_name",
          ascending: true,
        );

    setState(() {
      _loadedSubCategories = subjects;
      _loadedQuizzes = quizzes;
    });
  }

  void _loadCategories() async {
    final data = await supabase
        .from('category')
        .select('*')
        .limit(5)
        .order("category_name", ascending: true);

    List<HomeCategory> loadedCategories = [];

    for (final item in data) {
      loadedCategories.add(
        HomeCategory(
          name: item['category_name'],
          slug: item['category_seo_slug'],
          // ignore: prefer_interpolation_to_compose_strings
          image: 'https://mahatmaacademy.com' + item['category_image'],
        ),
      );
    }

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _homeCategories = loadedCategories;
      _selectedCategory = loadedCategories[0];
      _loadSingleCategory();
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(0, 48, 0, 70),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi ${supabase.auth.currentUser!.userMetadata!['name']}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          signOut(context, mounted);
                        },
                        child: const Stack(
                          clipBehavior: Clip.none,
                          children: <Widget>[
                            Icon(
                              Icons.logout,
                              size: 22,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'What would you learn today?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AllCategories(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in _homeCategories)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = item;
                            });
                            _loadSingleCategory();
                          },
                          child: Container(
                            width: 132,
                            height: 132,
                            color: const Color(0xff10bb6b).withAlpha(28),
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              children: [
                                Image.network(
                                  item.image,
                                  height: 80,
                                  width: 80,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedCategory.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(
                            text: "Subjects",
                          ),
                          Tab(
                            text: "Quizzes",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          children: [
                            ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Subjects",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            _loadedSubCategories.length >= 3,
                                        child: InkWell(
                                          child: const Text(
                                            "See All",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleCategory(
                                                  categorySlug:
                                                      _selectedCategory.slug,
                                                  initialIndex: 0,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      for (final item in _loadedSubCategories)
                                        InkWell(
                                          child: CategoriesCard(
                                            cardTitle:
                                                item['sub_category_name'],
                                            cardDescription: "",
                                            cardType: "SubCategory",
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SubCategoryPage(
                                                  subCategoryUrl: item[
                                                      'sub_category_seo_slug'],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Quizzes",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Visibility(
                                        visible: _loadedQuizzes.length >= 3,
                                        child: InkWell(
                                          child: const Text(
                                            "See All",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleCategory(
                                                        categorySlug:
                                                            _selectedCategory
                                                                .slug,
                                                        initialIndex: 1),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      for (final item in _loadedQuizzes)
                                        InkWell(
                                          child: CategoriesCard(
                                            cardTitle: item['quiz_name'],
                                            cardDescription: "",
                                            cardType: "Quiz",
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    QuizDetailsPage(
                                                        name: item['quiz_name'],
                                                        id: item['quiz_id']),
                                              ),
                                            );
                                          },
                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const LoadingSpinner();
  }
}
