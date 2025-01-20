import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/screens/topic.dart';
import 'dart:developer';


class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    log('StartScreen initialized');
  }

  @override
  Widget build(BuildContext context) {
    log('StartScreen build method called');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
           image: DecorationImage(
            image: AssetImage('assets/background5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  const SizedBox(height: 40),
                  Text(
                    "Learn With QuizFiesta",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Test your knowledge and improve your skills!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      log("Button pressed");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Topic()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      "Start Quiz",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
