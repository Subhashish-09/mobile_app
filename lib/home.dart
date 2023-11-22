import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/auth/sign_out.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/home/category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeCategory> _homeCategories = [];

  void _loadCategories() async {
    final data = await supabase.from('category').select('*');

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

    setState(() {
      _homeCategories = loadedCategories;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(
          padding: const EdgeInsets.fromLTRB(0, 48, 0, 70),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hi Subhashish',
                    style: TextStyle(
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
                    onTap: () {},
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
                  // for (final item in _homeCategories)
                  // CategoryGridItem(
                  //   title: item.title,
                  //   imageUrl: item.imageUrl,
                  //   onSelect: () {
                  //     setState(() {
                  //       selectedCategory = item.imageSlug;
                  //     });
                  //     _getCategoryData();
                  //   },
                  // ),
                ],
              ),
            ),
            // FxSpacing.height(24),
            // Padding(
            //   padding: FxSpacing.horizontal(24),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       FxText.titleMedium(
            //         catDetails.isEmpty ? '' : catDetails['category_title'],
            //         color: theme.colorScheme.onBackground,
            //         fontWeight: 600,
            //       ),
            //     ],
            //   ),
            // ),
            // FxSpacing.height(16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Padding(
                  //   padding: FxSpacing.zero,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       FxText.titleMedium(
                  //         'Subjects',
                  //         color: theme.colorScheme.onBackground,
                  //         fontWeight: 600,
                  //       ),
                  //       FxText.bodySmall(
                  //         'See All',
                  //         color: theme.colorScheme.onBackground,
                  //         fontWeight: 600,
                  //         xMuted: true,
                  //         letterSpacing: 0,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // FxSpacing.height(16),
                  // Padding(
                  //   padding: FxSpacing.zero,
                  //   child: Column(
                  //     children: [
                  //       for (final item in subjectDetails)
                  //         InkWell(
                  //           onTap: () {
                  //             chaptersCount == 0
                  //                 ? _loadScreens(
                  //                     context,
                  //                     SubjectPractiseTestsScreen(
                  //                       category: selectedCategory,
                  //                       subject: item['subject_slug'],
                  //                     ),
                  //                   )
                  //                 : _changeScreen(
                  //                     context,
                  //                     item['subject_slug'],
                  //                     selectedCategory,
                  //                     item['subject_image_url'],
                  //                   );
                  //           },
                  //           child: FxContainer(
                  //             margin: FxSpacing.bottom(16),
                  //             color: const Color.fromARGB(255, 240, 240, 240),
                  //             child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 FxContainer(
                  //                   color:
                  //                       const Color(0xff10bb6b).withAlpha(32),
                  //                   padding: FxSpacing.all(8),
                  //                   child: Hero(
                  //                     tag: item['subject_title'],
                  //                     child: ClipRRect(
                  //                       clipBehavior:
                  //                           Clip.antiAliasWithSaveLayer,
                  //                       child: Image.network(
                  //                         item['subject_image_url'],
                  //                         width: 72,
                  //                         height: 72,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 FxSpacing.width(16),
                  //                 Expanded(
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       FxText.bodyMedium(
                  //                         item['subject_title'],
                  //                         color: Theme.of(context)
                  //                             .colorScheme
                  //                             .onBackground,
                  //                         fontWeight: 600,
                  //                       ),
                  //                       FxSpacing.height(8),
                  //                       FxText.labelSmall(
                  //                         item['subject_description'],
                  //                         color: Theme.of(context)
                  //                             .colorScheme
                  //                             .onBackground,
                  //                         muted: true,
                  //                       ),
                  //                       FxSpacing.height(8),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         )
                  //     ],
                  //   ),
                  // ),
                  // if (quizzes.isNotEmpty)
                  //   Padding(
                  //     padding: FxSpacing.zero,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         FxText.titleMedium(
                  //           'Quizzes',
                  //           color: Theme.of(context).colorScheme.onBackground,
                  //           fontWeight: 600,
                  //         ),
                  //         FxText.bodySmall(
                  //           'See All',
                  //           color: Theme.of(context).colorScheme.onBackground,
                  //           fontWeight: 600,
                  //           xMuted: true,
                  //           letterSpacing: 0,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // FxSpacing.height(16),
                  // if (quizzes.isNotEmpty)
                  //   Padding(
                  //     padding: FxSpacing.zero,
                  //     child: Column(
                  //       children: [
                  //         for (final item in quizzes)
                  //           InkWell(
                  //             onTap: () {},
                  //             child: FxContainer(
                  //               color: const Color.fromARGB(255, 240, 240, 240),
                  //               margin: FxSpacing.bottom(16),
                  //               child: Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   FxContainer(
                  //                     color:
                  //                         const Color(0xff10bb6b).withAlpha(32),
                  //                     padding: FxSpacing.all(8),
                  //                     child: Hero(
                  //                       tag: item['otest_title'],
                  //                       child: ClipRRect(
                  //                         clipBehavior:
                  //                             Clip.antiAliasWithSaveLayer,
                  //                         child: Image.network(
                  //                           item['otest_image_url'],
                  //                           width: 72,
                  //                           height: 72,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   FxSpacing.width(16),
                  //                   Expanded(
                  //                     child: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         FxText.bodyMedium(
                  //                           item['otest_title'],
                  //                           color:
                  //                               theme.colorScheme.onBackground,
                  //                           fontWeight: 600,
                  //                         ),
                  //                         FxSpacing.height(8),
                  //                         FxText.labelSmall(
                  //                           item['otest_description'],
                  //                           color:
                  //                               theme.colorScheme.onBackground,
                  //                           muted: true,
                  //                         ),
                  //                         FxSpacing.height(8),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //       ],
                  //     ),
                  //   ),
                  // if (testSeries.isNotEmpty)
                  //   Padding(
                  //     padding: EdgeInsets.zero,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         FxText.titleMedium(
                  //           'Test Series',
                  //           color: Theme.of(context).colorScheme.onBackground,
                  //           fontWeight: 600,
                  //         ),
                  //         FxText.bodySmall(
                  //           'See All',
                  //           color: Theme.of(context).colorScheme.onBackground,
                  //           fontWeight: 600,
                  //           xMuted: true,
                  //           letterSpacing: 0,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  SizedBox(
                    height: 16,
                  ),
                  // if (testSeries.isNotEmpty)
                  //   Padding(
                  //     padding: EdgeInsets.zero,
                  //     child: Column(
                  //       children: [
                  //         for (final item in testSeries)
                  //           InkWell(
                  //             onTap: () {},
                  //             child: Container(
                  //               color: const Color.fromARGB(255, 240, 240, 240),
                  //               margin: EdgeInsets.only(bottom: 16),
                  //               child: Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Container(
                  //                     color:
                  //                         const Color(0xff10bb6b).withAlpha(32),
                  //                     padding: EdgeInsets.all(8),
                  //                     child: Hero(
                  //                       tag: item['series_title'],
                  //                       child: ClipRRect(
                  //                         clipBehavior:
                  //                             Clip.antiAliasWithSaveLayer,
                  //                         child: Image.network(
                  //                           item['series_image_url'],
                  //                           width: 72,
                  //                           height: 72,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(
                  //                     width: 16,
                  //                   ),
                  //                   Expanded(
                  //                     child: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           item['series_title'],
                  //                           style: TextStyle(
                  //                             color: Colors.black,
                  //                             fontWeight: FontWeight.w600,
                  //                             fontSize: 16,
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 8,
                  //                         ),
                  //                         FxText.labelSmall(
                  //                           item['series_description'],
                  //                           color:
                  //                               theme.colorScheme.onBackground,
                  //                           muted: true,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        )

        // Column(
        //   children: [
        //     const SizedBox(
        //       height: 25,
        //     ),
        //     for (final item in _homeCategories)
        //       GestureDetector(
        //         onTap: () {
        //           Navigator.of(context).push(
        //             CupertinoPageRoute(
        //               builder: (ctx) => SingleCategory(categorySlug: item.slug),
        //             ),
        //           );
        //         },
        //         child: Column(
        //           children: [
        //             Text(item.name),
        //             Image.network(
        //               item.image,
        //               height: 50,
        //               width: 75,
        //             ),
        //           ],
        //         ),
        //       ),
        //   ],
        // ),
        );
  }
}
