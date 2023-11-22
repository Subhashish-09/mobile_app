import 'package:flutter/material.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/home/category.dart';
import 'package:mobile_app/screens/categories/category.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<HomeCategory> _allCategories = [];

  void loadAllCategories() async {
    final categories = await supabase
        .from("category")
        .select()
        .order("category_name", ascending: true);

    List<HomeCategory> loadedCategories = [];

    for (final item in categories) {
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
      _allCategories = loadedCategories;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          for (final item in _allCategories)
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SingleCategory(
                      categorySlug: item.slug,
                      initialIndex: 0,
                    ),
                  ),
                );
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
      // ) Column(
      //   children: [for (final item in _allCategories) Text(item.name)],
      // ),
    );
  }
}
