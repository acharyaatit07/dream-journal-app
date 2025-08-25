// lib/features/dreams/models/dream.dart

import 'package:uuid/uuid.dart';

class Dream {
  final String id;
  final String title;
  final String content;
  final DateTime dreamDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int moodRating; // 1-7 scale
  final int sleepQuality; // 1-5 scale
  final int lucidityLevel; // 0-4 scale
  final List<String> tags;
  final String? category;
  final String? audioFilePath;
  final bool isFavorite;
  final DateTime? bedTime; // When user went to bed
  final DateTime? wakeTime; // When user woke up
  final int? dreamVividness; // 1-5 scale for how vivid/detailed the dream was

  const Dream({
    required this.id,
    required this.title,
    required this.content,
    required this.dreamDate,
    required this.createdAt,
    this.updatedAt,
    required this.moodRating,
    required this.sleepQuality,
    required this.lucidityLevel,
    this.tags = const [],
    this.category,
    this.audioFilePath,
    this.isFavorite = false,
    this.bedTime,
    this.wakeTime,
    this.dreamVividness,
  });

  // Factory constructor to create a new dream
  factory Dream.create({
    required String title,
    required String content,
    DateTime? dreamDate,
    int moodRating = 5,
    int sleepQuality = 3,
    int lucidityLevel = 0,
    List<String> tags = const [],
    String? category,
    String? audioFilePath,
    bool isFavorite = false,
    DateTime? bedTime,
    DateTime? wakeTime,
    int? dreamVividness,
  }) {
    const uuid = Uuid();
    final now = DateTime.now();

    return Dream(
      id: uuid.v4(),
      title: title,
      content: content,
      dreamDate: dreamDate ?? now,
      createdAt: now,
      moodRating: moodRating,
      sleepQuality: sleepQuality,
      lucidityLevel: lucidityLevel,
      tags: tags,
      category: category,
      audioFilePath: audioFilePath,
      isFavorite: isFavorite,
      bedTime: bedTime,
      wakeTime: wakeTime,
      dreamVividness: dreamVividness,
    );
  }

  // Create a copy with updated fields
  Dream copyWith({
    String? title,
    String? content,
    DateTime? dreamDate,
    int? moodRating,
    int? sleepQuality,
    int? lucidityLevel,
    List<String>? tags,
    String? category,
    String? audioFilePath,
    bool? isFavorite,
    DateTime? bedTime,
    DateTime? wakeTime,
    int? dreamVividness,
  }) {
    return Dream(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      dreamDate: dreamDate ?? this.dreamDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      moodRating: moodRating ?? this.moodRating,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      lucidityLevel: lucidityLevel ?? this.lucidityLevel,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      isFavorite: isFavorite ?? this.isFavorite,
      bedTime: bedTime ?? this.bedTime,
      wakeTime: wakeTime ?? this.wakeTime,
      dreamVividness: dreamVividness ?? this.dreamVividness,
    );
  }

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dream_date': dreamDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'mood_rating': moodRating,
      'sleep_quality': sleepQuality,
      'lucidity_level': lucidityLevel,
      'tags': tags.join(','),
      'category': category,
      'audio_file_path': audioFilePath,
      'is_favorite': isFavorite ? 1 : 0,
      'bed_time': bedTime?.toIso8601String(),
      'wake_time': wakeTime?.toIso8601String(),
      'dream_vividness': dreamVividness,
    };
  }

  // Create from Map (from database)
  factory Dream.fromMap(Map<String, dynamic> map) {
    return Dream(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      dreamDate: DateTime.parse(map['dream_date']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      moodRating: map['mood_rating'] ?? 5,
      sleepQuality: map['sleep_quality'] ?? 3,
      lucidityLevel: map['lucidity_level'] ?? 0,
      tags: map['tags'] != null && map['tags'].toString().isNotEmpty
          ? map['tags'].toString().split(',')
          : [],
      category: map['category'],
      audioFilePath: map['audio_file_path'],
      isFavorite: map['is_favorite'] == 1,
      bedTime: map['bed_time'] != null ? DateTime.parse(map['bed_time']) : null,
      wakeTime:
          map['wake_time'] != null ? DateTime.parse(map['wake_time']) : null,
      dreamVividness: map['dream_vividness'],
    );
  }

  // Utility getters
  String get formattedDate {
    return '${dreamDate.day}/${dreamDate.month}/${dreamDate.year}';
  }

  String get formattedDateTime {
    final hour = dreamDate.hour.toString().padLeft(2, '0');
    final minute = dreamDate.minute.toString().padLeft(2, '0');
    return '$formattedDate at $hour:$minute';
  }

  String get moodLabel {
    const labels = [
      'Terrible',
      'Bad',
      'Poor',
      'Okay',
      'Good',
      'Great',
      'Amazing'
    ];
    if (moodRating < 1 || moodRating > 7) return 'Unknown';
    return labels[moodRating - 1];
  }

  String get sleepQualityLabel {
    const labels = ['Very Poor', 'Poor', 'Fair', 'Good', 'Excellent'];
    if (sleepQuality < 1 || sleepQuality > 5) return 'Unknown';
    return labels[sleepQuality - 1];
  }

  String get lucidityLabel {
    const labels = [
      'Not Lucid',
      'Slightly Aware',
      'Somewhat Lucid',
      'Very Lucid',
      'Fully Lucid'
    ];
    if (lucidityLevel < 0 || lucidityLevel > 4) return 'Unknown';
    return labels[lucidityLevel];
  }

  bool get hasAudio => audioFilePath != null && audioFilePath!.isNotEmpty;

  int get wordCount =>
      content.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;

  // New sleep-related utility getters
  Duration? get sleepDuration {
    if (bedTime != null && wakeTime != null) {
      return wakeTime!.difference(bedTime!);
    }
    return null;
  }

  String? get sleepDurationFormatted {
    final duration = sleepDuration;
    if (duration != null) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    }
    return null;
  }

  String get dreamVividnessLabel {
    if (dreamVividness == null) return 'Not rated';
    const labels = [
      'Very Vague',
      'Vague',
      'Moderate',
      'Vivid',
      'Extremely Vivid'
    ];
    if (dreamVividness! < 1 || dreamVividness! > 5) return 'Unknown';
    return labels[dreamVividness! - 1];
  }

  // Estimate what sleep phase this dream occurred in
  String get estimatedSleepPhase {
    if (bedTime == null || wakeTime == null) return 'Unknown';

    final sleepDur = sleepDuration!;
    final dreamTime = dreamDate.difference(bedTime!);
    final percentThroughSleep = dreamTime.inMinutes / sleepDur.inMinutes;

    if (percentThroughSleep < 0.2) return 'Early Sleep';
    if (percentThroughSleep < 0.4) return 'Light Sleep';
    if (percentThroughSleep < 0.7) return 'Deep Sleep';
    if (percentThroughSleep < 0.9) return 'REM Sleep';
    return 'Wake Transition';
  }

  // Validation
  bool get isValid {
    return title.isNotEmpty &&
        content.isNotEmpty &&
        moodRating >= 1 &&
        moodRating <= 7 &&
        sleepQuality >= 1 &&
        sleepQuality <= 5 &&
        lucidityLevel >= 0 &&
        lucidityLevel <= 4;
  }

  @override
  String toString() => 'Dream(id: $id, title: $title, date: $formattedDate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Dream && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
