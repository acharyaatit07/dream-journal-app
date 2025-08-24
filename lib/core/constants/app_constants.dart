// lib/core/constants/app_constants.dart

class AppConstants {
  // App Information
  static const String appName = 'Dream Journal';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Record, understand, and interpret your dreams with AI insights';

  // Database
  static const String databaseName = 'dream_journal.db';
  static const int databaseVersion = 1;
  static const String dreamsTable = 'dreams';
  static const String usersTable = 'users';
  static const String insightsTable = 'insights';

  // Shared Preferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyThemeMode = 'theme_mode';

  // Dream Categories
  static const List<String> dreamCategories = [
    'Nightmare',
    'Lucid Dream',
    'Recurring Dream',
    'Flying Dream',
    'Adventure',
    'Romance',
    'Fantasy',
    'Memory',
    'Anxiety Dream',
    'Other'
  ];

  // Mood Scale (1-7)
  static const List<String> moodLabels = [
    'Terrible',
    'Bad',
    'Poor',
    'Okay',
    'Good',
    'Great',
    'Amazing'
  ];

  // Sleep Quality Scale (1-5)
  static const List<String> sleepQualityLabels = [
    'Very Poor',
    'Poor',
    'Fair',
    'Good',
    'Excellent'
  ];

  // Lucidity Levels (0-4)
  static const List<String> lucidityLevels = [
    'Not Lucid',
    'Slightly Aware',
    'Somewhat Lucid',
    'Very Lucid',
    'Fully Lucid'
  ];

  // Limits
  static const int maxDreamTitleLength = 100;
  static const int maxDreamContentLength = 10000;
  static const int maxTagsPerDream = 10;

  // Animation Durations
  static const int shortAnimationMs = 200;
  static const int mediumAnimationMs = 500;
  static const int longAnimationMs = 1000;
}

class AppStrings {
  // Navigation
  static const String home = 'Home';
  static const String dreams = 'Dreams';
  static const String insights = 'Insights';
  static const String analytics = 'Analytics';
  static const String settings = 'Settings';

  // Actions
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';

  // Dream Entry
  static const String addDream = 'Add Dream';
  static const String dreamTitle = 'Dream Title';
  static const String dreamContent = 'Tell us about your dream...';
  static const String dreamDate = 'Dream Date';
  static const String tags = 'Tags';
  static const String mood = 'Mood';
  static const String sleepQuality = 'Sleep Quality';
  static const String lucidity = 'Lucidity Level';

  // Errors
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorEmptyTitle = 'Please enter a dream title.';
  static const String errorEmptyContent = 'Please describe your dream.';

  // Success Messages
  static const String dreamSaved = 'Dream saved successfully!';
  static const String dreamDeleted = 'Dream deleted successfully.';
  static const String dreamUpdated = 'Dream updated successfully!';
}
