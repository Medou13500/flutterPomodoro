import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int workDuration = 25 * 60; // 25 minutes
  static const int breakDuration = 5 * 60; // 5 minutes

  int remainingSeconds = workDuration;
  bool isRunning = false;
  bool isWorkTime = true;
  int completedCycles = 0;

  Timer? _timer;

  void _startTimer() {
    if (isRunning) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() => isRunning = true);
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  //!  reset 
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      remainingSeconds = isWorkTime ? workDuration : breakDuration;
      isRunning = false;
    });
  }

  //! annulation
  void _tick() {
    if (remainingSeconds == 0) {
      _timer?.cancel();

      if (isWorkTime) {
        completedCycles++;
      }

      setState(() {
        isWorkTime = !isWorkTime;
        remainingSeconds = isWorkTime ? workDuration : breakDuration;
        isRunning = false;
      });

      // pop-up
      _showAlert(isWorkTime ? 'C’est reparti pour le travail 💪' : 'Pause bien méritée 😌');
    } else {
      setState(() => remainingSeconds--);
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pomodoro terminé'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Mise en place de mettre sous format date a timer
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$sec';
  }

  // Calcule sécurisé de la progression
  double _getProgress() {
    final total = isWorkTime ? workDuration : breakDuration;
    final elapsed = total - remainingSeconds;
    if (total <= 0) return 0.0;
    final progress = elapsed / total;
    return progress.clamp(0.0, 1.0); // évite les valeurs invalides
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusText = isWorkTime ? 'Temps de travail' : 'Pause';
    final progressColor = isWorkTime ? Colors.redAccent : Colors.greenAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Pomodoro Pro'),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                statusText,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              // progress cercle avec le timer au centre
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: _getProgress(),
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  Text(
                    _formatTime(remainingSeconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: isRunning ? _pauseTimer : _startTimer,
                    icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(isRunning ? 'Pause' : 'Démarrer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Cycles complétés : $completedCycles',
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
