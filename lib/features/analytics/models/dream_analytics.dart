// lib/features/analytics/models/dream_analytics.dart

import 'package:flutter/material.dart';

class DreamAnalytics {
  final int totalDreams;
  final int dreamStreak;
  final double averageMood;
  final double averageSleepQuality;
  final double averageLucidity;
  final Map<String, int> categoryDistribution;
  final List<MoodDataPoint> moodTrend;
  final List<FrequencyDataPoint> dreamFrequency;
  final List<SleepQualityDataPoint> sleepQualityTrend;
  final Map<String, dynamic> insights;

  const DreamAnalytics({
    required this.totalDreams,
    required this.dreamStreak,
    required this.averageMood,
    required this.averageSleepQuality,
    required this.averageLucidity,
    required this.categoryDistribution,
    required this.moodTrend,
    required this.dreamFrequency,
    required this.sleepQualityTrend,
    required this.insights,
  });

  // Helper getters for displaying data
  String get averageMoodLabel {
    const labels = [
      'Terrible',
      'Bad',
      'Poor',
      'Okay',
      'Good',
      'Great',
      'Amazing'
    ];
    final index = (averageMood - 1).round().clamp(0, 6);
    return labels[index];
  }

  String get averageSleepQualityLabel {
    const labels = ['Very Poor', 'Poor', 'Fair', 'Good', 'Excellent'];
    final index = (averageSleepQuality - 1).round().clamp(0, 4);
    return labels[index];
  }

  String get lucidityPercentage {
    return '${(averageLucidity * 25).toStringAsFixed(0)}%';
  }

  String get mostCommonCategory {
    if (categoryDistribution.isEmpty) return 'None';
    return categoryDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  int get mostCommonCategoryCount {
    if (categoryDistribution.isEmpty) return 0;
    return categoryDistribution.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .value;
  }

  double get dreamFrequencyPerWeek {
    if (dreamFrequency.isEmpty) return 0;
    final totalWeeks = dreamFrequency.length;
    return totalDreams / totalWeeks;
  }
}

class MoodDataPoint {
  final DateTime date;
  final double averageMood;
  final int dreamCount;

  const MoodDataPoint({
    required this.date,
    required this.averageMood,
    required this.dreamCount,
  });
}

class FrequencyDataPoint {
  final DateTime date;
  final int dreamCount;
  final String period; // 'daily', 'weekly', 'monthly'

  const FrequencyDataPoint({
    required this.date,
    required this.dreamCount,
    required this.period,
  });
}

class SleepQualityDataPoint {
  final DateTime date;
  final double averageSleepQuality;
  final double averageMood;

  const SleepQualityDataPoint({
    required this.date,
    required this.averageSleepQuality,
    required this.averageMood,
  });
}

class CategoryData {
  final String category;
  final int count;
  final double percentage;
  final Color color;

  const CategoryData({
    required this.category,
    required this.count,
    required this.percentage,
    required this.color,
  });
}

class DreamInsight {
  final String title;
  final String description;
  final String type; // 'positive', 'neutral', 'suggestion'
  final IconData icon;

  const DreamInsight({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
  });
}
