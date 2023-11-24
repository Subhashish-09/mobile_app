import 'package:flutter/material.dart';
import 'package:mobile_app/components/categories_card.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/home/topic.dart';
import 'package:mobile_app/screens/categories/topic.dart';

class SubCategoryPage extends StatefulWidget {
  const SubCategoryPage({super.key, required this.subCategoryUrl});

  final String subCategoryUrl;

  @override
  State<SubCategoryPage> createState() => _SubCategoryPage();
}

class _SubCategoryPage extends State<SubCategoryPage> {
  List<HomeTopic> _allTopics = [];

  Map _loadedSubCategory = {};

  bool _isLoaded = false;

  void _loadTopics() async {
    List<HomeTopic> loadedTopics = [];

    final subCategory = await supabase
        .from("subcategory")
        .select()
        .eq("sub_category_seo_slug", widget.subCategoryUrl)
        .single();

    final data = await supabase
        .from("topic")
        .select("*")
        .eq("sub_category", widget.subCategoryUrl);

    for (final item in data) {
      loadedTopics.add(
        HomeTopic(
          name: item['topic_name'],
          topicSlug: item['topic_seo_slug'],
        ),
      );
    }

    setState(() {
      _allTopics = loadedTopics;
      _isLoaded = true;
      _loadedSubCategory = subCategory;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(_loadedSubCategory['sub_category_name']),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (final item in _allTopics)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => TopicPage(
                            topicSlug: item.topicSlug,
                          ),
                        ),
                      );
                    },
                    child: CategoriesCard(
                      cardTitle: item.name,
                      cardDescription: "25 Practise Tests",
                      cardType: "Topic",
                    ),
                  )
              ],
            ),
          )
        : const LoadingSpinner();
  }
}
