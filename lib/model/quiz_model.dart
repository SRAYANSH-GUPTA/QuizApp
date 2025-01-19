class Quiz {
  final int id;
  final String name;
  final String title;
  final String description;
  final String difficultyLevel;
  final String topic;
  final DateTime time;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int duration;
  final DateTime endTime;
  final double negativeMarks;
  final double correctAnswerMarks;
  final bool shuffle;
  final bool showAnswers;
  final bool lockSolutions;
  final bool isForm;
  final bool showMasteryOption;
  final String readingMaterial;
  final String quizType;
  final bool isCustom;
  final String bannerId;
  final String examId;
  final bool showUnanswered;
  final String endsAt;
  final String lives;
  final String liveCount;
  final int coinCount;
  final int questionsCount;
  final String dailyDate;
  final int maxMistakeCount;
  final List<Question> questions;

  Quiz({
    required this.id,
    String? name,
    required this.title,
    required this.description,
    String? difficultyLevel,
    required this.topic,
    required this.time,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
    required this.duration,
    required this.endTime,
    required this.negativeMarks,
    required this.correctAnswerMarks,
    required this.shuffle,
    required this.showAnswers,
    required this.lockSolutions,
    required this.isForm,
    required this.showMasteryOption,
    String? readingMaterial,
    String? quizType,
    required this.isCustom,
    String? bannerId,
    String? examId,
    required this.showUnanswered,
    required this.endsAt,
    String? lives,
    required this.liveCount,
    required this.coinCount,
    required this.questionsCount,
    required this.dailyDate,
    required this.maxMistakeCount,
    required this.questions,
  })  : name = name ?? 'Undefined',
        difficultyLevel = difficultyLevel ?? 'Undefined',
        readingMaterial = readingMaterial ?? 'Undefined',
        quizType = quizType ?? 'Undefined',
        bannerId = bannerId ?? 'Undefined',
        examId = examId ?? 'Undefined',
        lives = lives ?? 'Undefined';

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      name: json['name'],
      title: json['title'] ?? 'Undefined',
      description: json['description'] ?? 'Undefined',
      difficultyLevel: json['difficulty_level'],
      topic: json['topic'] ?? 'Undefined',
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      isPublished: json['is_published'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? 0,
      endTime: DateTime.tryParse(json['end_time'] ?? '') ?? DateTime.now(),
      negativeMarks:
          double.tryParse(json['negative_marks']?.toString() ?? '0') ?? 0.0,
      correctAnswerMarks:
          double.tryParse(json['correct_answer_marks']?.toString() ?? '0') ??
              0.0,
      shuffle: json['shuffle'] ?? false,
      showAnswers: json['show_answers'] ?? false,
      lockSolutions: json['lock_solutions'] ?? false,
      isForm: json['is_form'] ?? false,
      showMasteryOption: json['show_mastery_option'] ?? false,
      readingMaterial: json['reading_material'],
      quizType: json['quiz_type'],
      isCustom: json['is_custom'] ?? false,
      bannerId: json['banner_id'],
      examId: json['exam_id'],
      showUnanswered: json['show_unanswered'] ?? false,
      endsAt: json['ends_at'] ?? 'Undefined',
      lives: json['lives'],
      liveCount: json['live_count'] ?? '0',
      coinCount: json['coin_count'] ?? 0,
      questionsCount: json['questions_count'] ?? 0,
      dailyDate: json['daily_date'] ?? 'Undefined',
      maxMistakeCount: json['max_mistake_count'] ?? 0,
      questions: (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final String description;
  final String difficultyLevel;
  final String topic;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String detailedSolution;
  final String type;
  final bool isMandatory;
  final bool showInFeed;
  final String pyqLabel;
  final List<Option> options;

  Question({
    required this.id,
    required this.description,
    String? difficultyLevel,
    required this.topic,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
    required this.detailedSolution,
    required this.type,
    required this.isMandatory,
    required this.showInFeed,
    required this.pyqLabel,
    required this.options,
  }) : difficultyLevel = difficultyLevel ?? 'Undefined';

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      description: json['description'] ?? 'Undefined',
      difficultyLevel: json['difficulty_level'],
      topic: json['topic'] ?? 'Undefined',
      isPublished: json['is_published'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      detailedSolution: json['detailed_solution'] ?? 'Undefined',
      type: json['type'] ?? 'Undefined',
      isMandatory: json['is_mandatory'] ?? false,
      showInFeed: json['show_in_feed'] ?? false,
      pyqLabel: json['pyq_label'] ?? 'Undefined',
      options:
          (json['options'] as List?)?.map((o) => Option.fromJson(o)).toList() ??
              [],
    );
  }
}

class Option {
  final int id;
  final String description;
  final int questionId;
  final bool isCorrect;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool unanswered;
  final String photoUrl;

  Option({
    required this.id,
    required this.description,
    required this.questionId,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
    required this.unanswered,
    String? photoUrl,
  }) : photoUrl = photoUrl ?? 'Undefined';

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? 0,
      description: json['description'] ?? 'Undefined',
      questionId: json['question_id'] ?? 0,
      isCorrect: json['is_correct'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      unanswered: json['unanswered'] ?? false,
      photoUrl: json['photo_url'],
    );
  }
}
