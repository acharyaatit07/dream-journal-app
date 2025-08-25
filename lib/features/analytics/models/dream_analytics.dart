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
  final SleepPatternAnalysis sleepPatterns;

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
    required this.sleepPatterns,
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

// New sleep pattern analysis models
class SleepPatternAnalysis {
  final SleepQualityCorrelation qualityCorrelation;
  final DreamTimingAnalysis timingAnalysis;
  final DreamRecallCorrelation recallCorrelation;
  final List<SleepInsight> sleepInsights;

  const SleepPatternAnalysis({
    required this.qualityCorrelation,
    required this.timingAnalysis,
    required this.recallCorrelation,
    required this.sleepInsights,
  });
}

class SleepQualityCorrelation {
  final double
      correlationCoefficient; // -1 to 1, correlation between sleep quality and dream mood
  final Map<int, double>
      sleepQualityToMoodMap; // Sleep quality (1-5) -> Average mood
  final Map<int, double>
      sleepQualityToVividnessMap; // Sleep quality -> Average vividness
  final String interpretation; // Human-readable interpretation

  const SleepQualityCorrelation({
    required this.correlationCoefficient,
    required this.sleepQualityToMoodMap,
    required this.sleepQualityToVividnessMap,
    required this.interpretation,
  });
}

class DreamTimingAnalysis {
  final Map<int, int> dreamsByHour; // Hour (0-23) -> Dream count
  final int mostCommonHour;
  final Map<String, int> dreamsBySleepPhase; // Sleep phase -> Count
  final double averageSleepDuration;
  final String optimalSleepDuration;

  const DreamTimingAnalysis({
    required this.dreamsByHour,
    required this.mostCommonHour,
    required this.dreamsBySleepPhase,
    required this.averageSleepDuration,
    required this.optimalSleepDuration,
  });
}

class DreamRecallCorrelation {
  final Map<int, double>
      sleepQualityToRecallRate; // Sleep quality -> Dream recall percentage
  final Map<int, double>
      sleepDurationToRecallRate; // Sleep duration (hours) -> Recall rate
  final double optimalSleepDurationForRecall;
  final List<String> recallFactors; // Factors that improve dream recall

  const DreamRecallCorrelation({
    required this.sleepQualityToRecallRate,
    required this.sleepDurationToRecallRate,
    required this.optimalSleepDurationForRecall,
    required this.recallFactors,
  });
}

class SleepInsight {
  final String title;
  final String description;
  final String actionItem;
  final double confidence; // 0-1, how confident we are in this insight
  final IconData icon;

  const SleepInsight({
    required this.title,
    required this.description,
    required this.actionItem,
    required this.confidence,
    required this.icon,
  });
}
