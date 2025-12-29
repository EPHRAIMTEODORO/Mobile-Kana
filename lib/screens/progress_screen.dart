import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/character_progress.dart';
import '../utils/storage_helper.dart';

enum ProgressFilter { all, learning, mastered }

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<CharacterProgress> _allProgress = [];
  List<CharacterProgress> _filteredProgress = [];
  ProgressFilter _currentFilter = ProgressFilter.all;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);
    try {
      final progress = await StorageHelper.loadProgress();
      setState(() {
        _allProgress = progress;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    switch (_currentFilter) {
      case ProgressFilter.all:
        _filteredProgress = _allProgress;
        break;
      case ProgressFilter.learning:
        _filteredProgress = _allProgress.where((p) => p.accuracy < 0.8).toList();
        break;
      case ProgressFilter.mastered:
        _filteredProgress = _allProgress.where((p) => p.accuracy >= 0.8).toList();
        break;
    }
  }

  Future<void> _clearProgress() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Progress'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StorageHelper.saveProgress([]);
      _loadProgress();
    }
  }

  int get _totalStudied => _allProgress.length;
  
  int get _totalCorrect => _allProgress.fold(0, (sum, p) => sum + p.correct);
  
  int get _totalIncorrect => _allProgress.fold(0, (sum, p) => sum + p.incorrect);
  
  int get _overallAccuracy {
    final total = _totalCorrect + _totalIncorrect;
    return total > 0 ? ((_totalCorrect / total) * 100).round() : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracking'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade50,
              Colors.teal.shade100,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _allProgress.isEmpty
                ? _buildEmptyState()
                : _buildProgressContent(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assessment_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'No progress data yet.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start learning to track your progress!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Start Learning'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressContent() {
    return Column(
      children: [
        _buildSummaryStats(),
        const SizedBox(height: 16),
        _buildFilterButtons(),
        const SizedBox(height: 16),
        Expanded(child: _buildProgressList()),
        _buildClearButton(),
      ],
    );
  }

  Widget _buildSummaryStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Characters\nStudied',
              _totalStudied.toString(),
              Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Overall\nAccuracy',
              '$_overallAccuracy%',
              Colors.green.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Correct\nAnswers',
              _totalCorrect.toString(),
              Colors.purple.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Incorrect\nAnswers',
              _totalIncorrect.toString(),
              Colors.orange.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterButton(
              'All',
              ProgressFilter.all,
              _allProgress.length,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterButton(
              'Learning',
              ProgressFilter.learning,
              _allProgress.where((p) => p.accuracy < 0.8).length,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterButton(
              'Mastered',
              ProgressFilter.mastered,
              _allProgress.where((p) => p.accuracy >= 0.8).length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, ProgressFilter filter, int count) {
    final isSelected = _currentFilter == filter;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentFilter = filter;
          _applyFilter();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green.shade600 : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        elevation: isSelected ? 4 : 1,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        children: [
          Text(label),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressList() {
    if (_filteredProgress.isEmpty) {
      return Center(
        child: Text(
          'No characters match this filter',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredProgress.length,
      itemBuilder: (context, index) {
        final progress = _filteredProgress[index];
        return _buildProgressCard(progress);
      },
    );
  }

  Widget _buildProgressCard(CharacterProgress progress) {
    final accuracy = (progress.accuracy * 100).round();
    final accuracyColor = accuracy >= 80 ? Colors.green.shade500 : Colors.orange.shade500;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              progress.character,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accuracy: $accuracy%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Correct: ${progress.correct} | Incorrect: ${progress.incorrect}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress.accuracy,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(accuracyColor),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last reviewed: ${dateFormat.format(progress.lastReviewed)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _clearProgress,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade500,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Clear All Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
