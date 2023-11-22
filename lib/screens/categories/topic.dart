import 'package:flutter/material.dart';
import 'package:mobile_app/components/categories_card.dart';
import 'package:mobile_app/helpers/loading_spinner.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/practise/details.dart';
import 'package:mobile_app/screens/practise.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key, required this.topicSlug});

  final String topicSlug;

  @override
  State<TopicPage> createState() => _TopicPage();
}

class _TopicPage extends State<TopicPage> {
  List<PractiseDetails> _allPractises = [];
  bool _isLoaded = false;
  Map _loadedTopic = {};

  void _loadPractiseTests() async {
    List<PractiseDetails> loadedPractises = [];

    final topic = await supabase
        .from("topic")
        .select()
        .eq("topic_seo_slug", widget.topicSlug)
        .single();

    final data = await supabase
        .from("practise")
        .select("*")
        .eq("practise_topic", widget.topicSlug);

    for (final item in data) {
      loadedPractises.add(
        PractiseDetails(
          name: item['practise_name'],
          practiseId: item['practise_id'],
        ),
      );
    }

    setState(() {
      _allPractises = loadedPractises;
      _loadedTopic = topic;
      _isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPractiseTests();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                _loadedTopic['topic_name'],
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (final item in _allPractises)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              PractisePage(practiseId: item.practiseId),
                        ),
                      );
                    },
                    child: CategoriesCard(
                      cardTitle: item.name,
                      cardDescription: "25 Practise Tests",
                    ),
                  )
              ],
            ),
          )
        : const LoadingSpinner();
  }
}
