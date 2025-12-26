import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'chart_screen.dart';
import 'kanji_browser_screen.dart';
import 'flashcard_screen.dart';
import 'quiz_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 40),
                _buildAnimatedCharacters(),
                const SizedBox(height: 40),
                _buildNavigationCards(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learn Kana',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Master Hiragana, Katakana & Kanji',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildAnimatedCharacters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnimatedChar('あ', AppColors.kanaGradientStart),
        _buildAnimatedChar('ア', AppColors.kanaGradientEnd),
        _buildAnimatedChar('漢', AppColors.kanjiGradientStart),
        _buildAnimatedChar('字', AppColors.kanjiGradientEnd),
      ],
    );
  }

  Widget _buildAnimatedChar(String char, Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCards(BuildContext context) {
    return Column(
      children: [
        _buildNavigationCard(
          context,
          icon: Icons.grid_view_rounded,
          title: 'Kana Chart',
          subtitle: 'Reference for 92 characters',
          gradient: const LinearGradient(
            colors: [AppColors.kanaGradientStart, AppColors.kanaGradientEnd],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChartScreen()),
          ),
        ),
        const SizedBox(height: 16),
        _buildNavigationCard(
          context,
          icon: Icons.language,
          title: 'Kanji',
          subtitle: '2,140 Jōyō Kanji by grade',
          gradient: const LinearGradient(
            colors: [AppColors.kanjiGradientStart, AppColors.kanjiGradientEnd],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KanjiBrowserScreen()),
          ),
        ),
        const SizedBox(height: 16),
        _buildNavigationCard(
          context,
          icon: Icons.style,
          title: 'Flashcards',
          subtitle: 'Interactive learning mode',
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.purple.shade400],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FlashcardScreen()),
          ),
        ),
        const SizedBox(height: 16),
        _buildNavigationCard(
          context,
          icon: Icons.quiz,
          title: 'Quiz Mode',
          subtitle: 'Test your knowledge',
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.teal.shade400],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuizScreen()),
          ),
        ),
        const SizedBox(height: 16),
        _buildNavigationCard(
          context,
          icon: Icons.insights,
          title: 'Progress',
          subtitle: 'Track your learning',
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.red.shade400],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProgressScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
