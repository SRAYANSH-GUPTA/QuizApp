import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/screens/topic.dart' as topic;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/providers/coin_provider.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultState();
}

class _ResultState extends ConsumerState<ResultScreen> {
  late int earnedCoins;

  @override
  void initState() {
    super.initState();
    _calculateAndSaveCoins();
  }

  Future<void> _calculateAndSaveCoins() async {
    final score = ref.read(quizProvider.notifier).calculateScore();
    earnedCoins = _calculateCoins(score);

    // Use the coinProvider to update coins
    await ref.read(coinProvider.notifier).addCoins(earnedCoins);

    if (mounted) {
      setState(() {});
    }
  }

  int _calculateCoins(double score) {
    // Coin strategy:
    // Score >= 90: 100 coins
    // Score >= 80: 80 coins
    // Score >= 70: 60 coins
    // Score >= 60: 40 coins
    // Score >= 50: 20 coins
    // Below 50: 10 coins
    if (score >= 90) return 100;
    if (score >= 80) return 80;
    if (score >= 70) return 60;
    if (score >= 60) return 40;
    if (score >= 50) return 20;
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final correctAnswers =
        ref.read(quizProvider.notifier).getCorrectAnswersCount();
    final score = ref.read(quizProvider.notifier).calculateScore();
    final totalQuestions = quizState.questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgorund2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Quiz Results',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$correctAnswers',
                              style: GoogleFonts.poppins(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'out of $totalQuestions correct',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+$earnedCoins coins',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Score: ${score.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.read(quizProvider.notifier).resetQuiz();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const topic.Topic()),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(
                              'Try Again',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Question Details',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final question = quizState.questions[index];
                    final selectedAnswer =
                        quizState.selectedAnswers[question.id];
                    final correctOption =
                        question.options.firstWhere((o) => o.isCorrect);
                    final isCorrect =
                        selectedAnswer == correctOption.description;

                    return QuestionResultCard(
                      questionIndex: index,
                      question: question.description,
                      selectedAnswer: selectedAnswer ?? 'Not answered',
                      correctAnswer: correctOption.description,
                      isCorrect: isCorrect,
                      solution: question.detailedSolution,
                    );
                  },
                  childCount: quizState.questions.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionResultCard extends StatefulWidget {
  final int questionIndex;
  final String question;
  final String selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String solution;

  const QuestionResultCard({
    super.key,
    required this.questionIndex,
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.solution,
  });

  @override
  State<QuestionResultCard> createState() => _QuestionResultCardState();
}

class _QuestionResultCardState extends State<QuestionResultCard> {
  bool showSolution = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: widget.isCorrect
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.isCorrect ? Colors.green : Colors.red,
                  child: Text(
                    (widget.questionIndex + 1).toString(),
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.question,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnswerRow('Your Answer:', widget.selectedAnswer,
                widget.isCorrect ? Colors.green : Colors.red),
            const SizedBox(height: 8),
            _buildAnswerRow(
                'Correct Answer:', widget.correctAnswer, Colors.green),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showSolution = !showSolution;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
              child: Text(
                showSolution ? 'Hide Solution' : 'Show Solution',
                style: GoogleFonts.poppins(),
              ),
            ),
            if (showSolution) ...[
              const SizedBox(height: 16),
              Text(
                'Solution:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.solution,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(String label, String answer, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
