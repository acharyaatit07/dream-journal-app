// lib/features/analytics/screens/analytics_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../dreams/services/dreams_provider.dart';
import '../models/dream_analytics.dart';
import '../services/analytics_service.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dream Analytics'),
        elevation: 0,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: analyticsAsync.when(
        data: (analytics) => _buildAnalytics(context, analytics),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading analytics: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalytics(BuildContext context, DreamAnalytics analytics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(context, analytics),
          const SizedBox(height: 24),
          _buildSleepPatternSection(context, analytics.sleepPatterns),
          const SizedBox(height: 24),
          _buildCategoryChart(context, analytics),
          const SizedBox(height: 24),
          _buildInsightsSection(context, analytics),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, DreamAnalytics analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Total Dreams',
                analytics.totalDreams.toString(),
                Icons.bedtime,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Dream Streak',
                '${analytics.dreamStreak} days',
                Icons.local_fire_department,
                AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Avg Mood',
                analytics.averageMoodLabel,
                Icons.sentiment_satisfied,
                AppColors.getMoodColor(analytics.averageMood.round()),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                'Sleep Quality',
                analytics.averageSleepQualityLabel,
                Icons.hotel,
                AppColors.getSleepQualityColor(
                    analytics.averageSleepQuality.round()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context, DreamAnalytics analytics) {
    if (analytics.categoryDistribution.isEmpty) {
      return _buildEmptyChart(context, 'Dream Categories',
          'Add dream categories to see distribution');
    }

    final categoryData = AnalyticsService.getCategoryDataForChart(
        analytics.categoryDistribution);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dream Categories',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 0.5),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: categoryData.map((data) {
                      return PieChartSectionData(
                        color: data.color,
                        value: data.percentage,
                        title: '${data.percentage.toStringAsFixed(0)}%',
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        radius: 60,
                      );
                    }).toList(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: categoryData.map((data) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: data.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${data.category} (${data.count})',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart(BuildContext context, String title, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 0.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48,
                color: AppColors.textSecondaryLight.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context, DreamAnalytics analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Insights',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        if (analytics.totalDreams > 0) ...[
          _buildInsightCard(
            context,
            'Most Common Dream',
            '${analytics.mostCommonCategory} appears in ${analytics.mostCommonCategoryCount} dreams',
            Icons.trending_up,
            AppColors.accent,
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            context,
            'Dream Frequency',
            'You record ${analytics.dreamFrequencyPerWeek.toStringAsFixed(1)} dreams per week on average',
            Icons.schedule,
            AppColors.primary,
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            context,
            'Lucidity Progress',
            'Your lucidity rate is ${analytics.lucidityPercentage}',
            Icons.psychology,
            AppColors.getLucidityColor(analytics.averageLucidity.round()),
          ),
        ] else ...[
          _buildInsightCard(
            context,
            'Start Your Journey',
            'Add your first dream to begin discovering patterns and insights',
            Icons.lightbulb_outline,
            AppColors.accent,
          ),
        ],
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context, String title,
      String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepPatternSection(
      BuildContext context, SleepPatternAnalysis sleepPatterns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep Patterns',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),

        // Sleep Quality Correlation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology, color: AppColors.accent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Sleep Quality vs Dream Mood',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                sleepPatterns.qualityCorrelation.interpretation,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
              if (sleepPatterns
                  .qualityCorrelation.sleepQualityToMoodMap.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: sleepPatterns
                      .qualityCorrelation.sleepQualityToMoodMap.entries
                      .map((entry) {
                    final quality = entry.key;
                    final mood = entry.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.getSleepQualityColor(quality)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.getSleepQualityColor(quality)
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Quality $quality → Mood ${mood.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.getSleepQualityColor(quality),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Dream Timing Analysis
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Dream Timing Patterns',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTimingStatCard(
                      context,
                      'Most Common Time',
                      '${sleepPatterns.timingAnalysis.mostCommonHour.toString().padLeft(2, '0')}:00',
                      Icons.access_time,
                      AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimingStatCard(
                      context,
                      'Avg Sleep Duration',
                      '${sleepPatterns.timingAnalysis.averageSleepDuration.toStringAsFixed(1)}h',
                      Icons.hotel,
                      AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                sleepPatterns.timingAnalysis.optimalSleepDuration,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Sleep Insights
        if (sleepPatterns.sleepInsights.isNotEmpty) ...[
          Text(
            'Sleep Insights',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ...sleepPatterns.sleepInsights.map((insight) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight, width: 0.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Icon(insight.icon, color: AppColors.accent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insight.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                    ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Action: ${insight.actionItem}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ],
    );
  }

  Widget _buildTimingStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
