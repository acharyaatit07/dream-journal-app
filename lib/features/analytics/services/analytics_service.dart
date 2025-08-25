// lib/features/analytics/services/analytics_service.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../dreams/models/dream.dart';
import '../models/dream_analytics.dart';

class AnalyticsService {
  static DreamAnalytics calculateAnalytics(List<Dream> dreams) {
    if (dreams.isEmpty) {
      return DreamAnalytics(
        totalDreams: 0,
        dreamStreak: 0,
        averageMood: 5.0,
        averageSleepQuality: 3.0,
        averageLucidity: 0.0,
        categoryDistribution: {},
        moodTrend: [],
        dreamFrequency: [],
        sleepQualityTrend: [],
        insights: {},
      );
    }

    return DreamAnalytics(
      totalDreams: dreams.length,
      dreamStreak: _calculateDreamStreak(dreams),
      averageMood: _calculateAverageMood(dreams),
      averageSleepQuality: _calculateAverageSleepQuality(dreams),
      averageLucidity: _calculateAverageLucidity(dreams),
      categoryDistribution: _calculateCategoryDistribution(dreams),
      moodTrend: _calculateMoodTrend(dreams),
      dreamFrequency: _calculateDreamFrequency(dreams),
      sleepQualityTrend: _calculateSleepQualityTrend(dreams),
      insights: _generateInsights(dreams),
    );
  }

  static int _calculateDreamStreak(List<Dream> dreams) {
    if (dreams.isEmpty) return 0;

    dreams.sort((a, b) => b.dreamDate.compareTo(a.dreamDate));

    int streak = 0;
    DateTime currentDate = DateTime.now();

    for (final dream in dreams) {
      final dreamDate = DateTime(
          dream.dreamDate.year, dream.dreamDate.month, dream.dreamDate.day);
      final checkDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      final difference = checkDate.difference(dreamDate).inDays;

      if (difference == streak) {
        streak++;
        currentDate = dreamDate;
      } else if (difference > streak + 1) {
        break;
      }
    }

    return streak;
  }

  static double _calculateAverageMood(List<Dream> dreams) {
    if (dreams.isEmpty) return 5.0;
    final sum = dreams.map((d) => d.moodRating).reduce((a, b) => a + b);
    return sum / dreams.length;
  }

  static double _calculateAverageSleepQuality(List<Dream> dreams) {
    if (dreams.isEmpty) return 3.0;
    final sum = dreams.map((d) => d.sleepQuality).reduce((a, b) => a + b);
    return sum / dreams.length;
  }

  static double _calculateAverageLucidity(List<Dream> dreams) {
    if (dreams.isEmpty) return 0.0;
    final sum = dreams.map((d) => d.lucidityLevel).reduce((a, b) => a + b);
    return sum / dreams.length;
  }

  static Map<String, int> _calculateCategoryDistribution(List<Dream> dreams) {
    final Map<String, int> distribution = {};

    for (final dream in dreams) {
      final category = dream.category ?? 'Other';
      distribution[category] = (distribution[category] ?? 0) + 1;
    }

    return Map.fromEntries(distribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
  }

  static List<MoodDataPoint> _calculateMoodTrend(List<Dream> dreams) {
    if (dreams.isEmpty) return [];

    final Map<String, List<Dream>> dreamsByWeek = {};

    for (final dream in dreams) {
      final weekKey = _getWeekKey(dream.dreamDate);
      dreamsByWeek[weekKey] = dreamsByWeek[weekKey] ?? [];
      dreamsByWeek[weekKey]!.add(dream);
    }

    final List<MoodDataPoint> moodTrend = [];

    dreamsByWeek.forEach((weekKey, weekDreams) {
      final averageMood =
          weekDreams.map((d) => d.moodRating).reduce((a, b) => a + b) /
              weekDreams.length;

      moodTrend.add(MoodDataPoint(
        date: weekDreams.first.dreamDate,
        averageMood: averageMood,
        dreamCount: weekDreams.length,
      ));
    });

    moodTrend.sort((a, b) => a.date.compareTo(b.date));
    return moodTrend.take(12).toList(); // Last 12 weeks
  }

  static List<FrequencyDataPoint> _calculateDreamFrequency(List<Dream> dreams) {
    if (dreams.isEmpty) return [];

    final Map<String, int> dreamsByWeek = {};

    for (final dream in dreams) {
      final weekKey = _getWeekKey(dream.dreamDate);
      dreamsByWeek[weekKey] = (dreamsByWeek[weekKey] ?? 0) + 1;
    }

    final List<FrequencyDataPoint> frequency = [];

    dreamsByWeek.forEach((weekKey, count) {
      final date = DateTime.parse('${weekKey}T00:00:00');
      frequency.add(FrequencyDataPoint(
        date: date,
        dreamCount: count,
        period: 'weekly',
      ));
    });

    frequency.sort((a, b) => a.date.compareTo(b.date));
    return frequency.take(12).toList(); // Last 12 weeks
  }

  static List<SleepQualityDataPoint> _calculateSleepQualityTrend(
      List<Dream> dreams) {
    if (dreams.isEmpty) return [];

    final Map<String, List<Dream>> dreamsByWeek = {};

    for (final dream in dreams) {
      final weekKey = _getWeekKey(dream.dreamDate);
      dreamsByWeek[weekKey] = dreamsByWeek[weekKey] ?? [];
      dreamsByWeek[weekKey]!.add(dream);
    }

    final List<SleepQualityDataPoint> sleepTrend = [];

    dreamsByWeek.forEach((weekKey, weekDreams) {
      final averageSleep =
          weekDreams.map((d) => d.sleepQuality).reduce((a, b) => a + b) /
              weekDreams.length;
      final averageMood =
          weekDreams.map((d) => d.moodRating).reduce((a, b) => a + b) /
              weekDreams.length;

      sleepTrend.add(SleepQualityDataPoint(
        date: weekDreams.first.dreamDate,
        averageSleepQuality: averageSleep,
        averageMood: averageMood,
      ));
    });

    sleepTrend.sort((a, b) => a.date.compareTo(b.date));
    return sleepTrend.take(12).toList(); // Last 12 weeks
  }

  static String _getWeekKey(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
  }

  static Map<String, dynamic> _generateInsights(List<Dream> dreams) {
    final insights = <String, dynamic>{};

    if (dreams.isEmpty) return insights;

    // Most active day
    final dayCount = <int, int>{};
    for (final dream in dreams) {
      final day = dream.dreamDate.weekday;
      dayCount[day] = (dayCount[day] ?? 0) + 1;
    }

    final mostActiveDay =
        dayCount.entries.reduce((a, b) => a.value > b.value ? a : b);

    const dayNames = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    insights['mostActiveDay'] = dayNames[mostActiveDay.key];
    insights['mostActiveDayCount'] = mostActiveDay.value;

    // Mood improvement
    final recentDreams = dreams.take(10).toList();
    final olderDreams = dreams.skip(10).take(10).toList();

    if (recentDreams.isNotEmpty && olderDreams.isNotEmpty) {
      final recentMood =
          recentDreams.map((d) => d.moodRating).reduce((a, b) => a + b) /
              recentDreams.length;
      final olderMood =
          olderDreams.map((d) => d.moodRating).reduce((a, b) => a + b) /
              olderDreams.length;

      insights['moodChange'] = recentMood - olderMood;
      insights['moodImproving'] = recentMood > olderMood;
    }

    // Favorite tags
    final tagCount = <String, int>{};
    for (final dream in dreams) {
      for (final tag in dream.tags) {
        tagCount[tag] = (tagCount[tag] ?? 0) + 1;
      }
    }

    if (tagCount.isNotEmpty) {
      final topTags = tagCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      insights['topTags'] = topTags.take(5).map((e) => e.key).toList();
    }

    return insights;
  }

  static List<CategoryData> getCategoryDataForChart(
      Map<String, int> distribution) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return [];

    return distribution.entries.map((entry) {
      return CategoryData(
        category: entry.key,
        count: entry.value,
        percentage: (entry.value / total) * 100,
        color: AppColors.getDreamCategoryColor(entry.key),
      );
    }).toList();
  }
}
