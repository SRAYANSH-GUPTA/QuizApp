import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/model/quiz_model.dart';
import "package:quiz_app/services/questions_fetch.dart";

// State class to hold quiz-related data
class QuizState {
  final String? selectedTopic;
  final List<Quiz> quizzes;
  final List<Question> questions;
  final Map<int, String> selectedAnswers; // questionId -> selected answer
  final bool isLoading;
  final String? error;
  final Quiz? currentQuiz;

  QuizState({
    this.selectedTopic,
    this.quizzes = const [],
    this.questions = const [],
    this.selectedAnswers = const {},
    this.isLoading = false,
    this.error,
    this.currentQuiz,
  });

  QuizState copyWith({
    String? selectedTopic,
    List<Quiz>? quizzes,
    List<Question>? questions,
    Map<int, String>? selectedAnswers,
    bool? isLoading,
    String? error,
    Quiz? currentQuiz,
  }) {
    return QuizState(
      selectedTopic: selectedTopic ?? this.selectedTopic,
      quizzes: quizzes ?? this.quizzes,
      questions: questions ?? this.questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentQuiz: currentQuiz ?? this.currentQuiz,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState());

  Future<void> setTopic(String topic) async {
    if(mounted)
    {
      state = state.copyWith(
        selectedTopic: topic,
        isLoading: true,
        error: null,
      );
    }


    try {
      final quiz = await QuestionsFetch().fetchQuestions();

      // Filter questions based on the selected topic
      if (quiz.topic == topic) {
        state = state.copyWith(
          currentQuiz: quiz,
          questions: quiz.questions,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: 'No questions available for this topic',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  // Store user's selected answer for a question
  void selectAnswer(int questionId, String answer) {
    final updatedAnswers = Map<int, String>.from(state.selectedAnswers);
    updatedAnswers[questionId] = answer;

    state = state.copyWith(selectedAnswers: updatedAnswers);
  }

  // Get questions for a specific quiz
  void setQuizQuestions(int quizId) {
    final quiz = state.quizzes.firstWhere((q) => q.id == quizId);
    state = state.copyWith(questions: quiz.questions);
  }

  // Calculate score based on selected answers
  double calculateScore() {
    double score = 0;
    for (var question in state.questions) {
      final selectedAnswer = state.selectedAnswers[question.id];
      if (selectedAnswer != null) {
        final correctOption = question.options.firstWhere((o) => o.isCorrect);
        if (selectedAnswer == correctOption.description) {
          score += state.quizzes.first.correctAnswerMarks;
        } else {
          score -= state.quizzes.first.negativeMarks;
        }
      }
    }
    return score;
  }

  // Get the number of correct answers
  int getCorrectAnswersCount() {
    int count = 0;
    for (var question in state.questions) {
      final selectedAnswer = state.selectedAnswers[question.id];
      if (selectedAnswer != null) {
        final correctOption = question.options.firstWhere((o) => o.isCorrect);
        if (selectedAnswer == correctOption.description) {
          count++;
        }
      }
    }
    return count;
  }

  // Reset the quiz state
  void resetQuiz() {
    state = QuizState(selectedTopic: state.selectedTopic);
  }

  // Check if all questions are answered
  bool isQuizComplete() {
    return state.questions
        .every((q) => state.selectedAnswers.containsKey(q.id));
  }
}

// Provider definition
final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});

// Convenience providers for specific states
final selectedTopicProvider = Provider<String?>((ref) {
  return ref.watch(quizProvider).selectedTopic;
});

final questionsProvider = Provider<List<Question>>((ref) {
  return ref.watch(quizProvider).questions;
});

final selectedAnswersProvider = Provider<Map<int, String>>((ref) {
  return ref.watch(quizProvider).selectedAnswers;
});

final quizScoreProvider = Provider<double>((ref) {
  return ref.read(quizProvider.notifier).calculateScore();
});

final isQuizCompleteProvider = Provider<bool>((ref) {
  return ref.read(quizProvider.notifier).isQuizComplete();
});
