import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'dart:async';
import "dart:convert";
import 'package:quiz_app/model/quiz_model.dart';
import 'package:quiz_app/screens/result_screen.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  final String topic;
  const QuestionScreen({required this.topic, super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionState();
}

class _QuestionState extends ConsumerState<QuestionScreen> {
  late Timer _timer;
  int _remainingTime = 0;
  var currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to schedule the initialization after the build
    Future.microtask(() => _initializeQuiz());
  }

  Future<void> _initializeQuiz() async {
    // Initialize the quiz
    await ref.read(quizProvider.notifier).setTopic(widget.topic);

    // Only set the timer if the widget is still mounted
    if (mounted) {
      final currentQuiz = ref.read(quizProvider).currentQuiz;
      if (currentQuiz != null) {
        setState(() {
          _remainingTime = currentQuiz.duration * 60;
        });
        startTimer();
      }
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        // End quiz when time runs out
        navigateToResult();
      }
    });
  }

  void navigateToResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ResultScreen(),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void answerQuestion(String selectedAnswer) {
    final questions = ref.read(questionsProvider);
    final currentQuestion = questions[currentQuestionIndex];

    // Record the answer
    ref.read(quizProvider.notifier).selectAnswer(
          currentQuestion.id,
          selectedAnswer,
        );

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _timer.cancel();
      navigateToResult();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    if (quizState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (quizState.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            quizState.error!,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ),
      );
    }

    if (quizState.questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No questions available',
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    final currentQuestion = quizState.questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}/${quizState.questions.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        formatTime(_remainingTime),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value:
                      (currentQuestionIndex + 1) / quizState.questions.length,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      currentQuestion.description,
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      return AnswerButton(
                        option.description,
                        () => answerQuestion(option.description),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnswerButton extends ConsumerWidget {
  const AnswerButton(this.answerText, this.onTap, {super.key});

  final String answerText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        onPressed: onTap,
        child: Text(
          answerText,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
