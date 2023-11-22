class PractiseQuestions {
  const PractiseQuestions({
    required this.questionNo,
    required this.questionType,
    required this.category,
    required this.subcategory,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.solution,
    required this.optionsLength,
  });

  final int questionNo;
  final String questionType;
  final String category;
  final String subcategory;
  final String topic;
  final String question;
  final List options;
  final Map correctOption;
  final String solution;
  final int optionsLength;
}
