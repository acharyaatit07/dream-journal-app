// lib/features/dreams/screens/enhanced_dream_entry_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../models/dream.dart';
import '../services/dreams_provider.dart';

class EnhancedDreamEntryScreen extends ConsumerStatefulWidget {
  final Dream? dreamToEdit;

  const EnhancedDreamEntryScreen({
    super.key,
    this.dreamToEdit,
  });

  @override
  ConsumerState<EnhancedDreamEntryScreen> createState() =>
      _EnhancedDreamEntryScreenState();
}

class _EnhancedDreamEntryScreenState
    extends ConsumerState<EnhancedDreamEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  String? _selectedCategory;
  int _moodRating = 5;
  int _sleepQuality = 3;
  int _lucidityLevel = 0;
  int? _dreamVividness = 3;
  DateTime _dreamDate = DateTime.now();
  DateTime? _bedTime;
  DateTime? _wakeTime;
  List<String> _tags = [];
  bool _isFavorite = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.dreamToEdit != null) {
      final dream = widget.dreamToEdit!;
      _titleController.text = dream.title;
      _contentController.text = dream.content;
      _selectedCategory = dream.category;
      _moodRating = dream.moodRating;
      _sleepQuality = dream.sleepQuality;
      _lucidityLevel = dream.lucidityLevel;
      _dreamDate = dream.dreamDate;
      _bedTime = dream.bedTime;
      _wakeTime = dream.wakeTime;
      _dreamVividness = dream.dreamVividness;
      _tags = List.from(dream.tags);
      _isFavorite = dream.isFavorite;
      _tagsController.text = _tags.join(', ');
    } else {
      // Set default wake time to now for new dreams
      _wakeTime = DateTime.now();
      // Set default bed time to 8 hours before wake time
      _bedTime = _wakeTime!.subtract(const Duration(hours: 8));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dreamToEdit != null ? 'Edit Dream' : 'Add Dream'),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
            color: _isFavorite ? Colors.red : null,
          ),
          TextButton(
            onPressed: _isSaving ? null : _saveDream,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 24),
              _buildContentField(),
              const SizedBox(height: 24),
              _buildCategorySelection(),
              const SizedBox(height: 24),
              _buildTagsField(),
              const SizedBox(height: 24),
              _buildSleepTimingSection(),
              const SizedBox(height: 24),
              _buildRatingsSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dream Title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'What was your dream about?',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a dream title';
            }
            if (value.length > AppConstants.maxDreamTitleLength) {
              return 'Title too long (max ${AppConstants.maxDreamTitleLength} characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dream Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${_contentController.text.length} words',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contentController,
          decoration: const InputDecoration(
            hintText: 'Describe your dream in detail...',
            alignLabelWithHint: true,
          ),
          maxLines: 8,
          onChanged: (value) => setState(() {}), // Update word count
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please describe your dream';
            }
            if (value.length > AppConstants.maxDreamContentLength) {
              return 'Description too long (max ${AppConstants.maxDreamContentLength} characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dream Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.dreamCategories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedCategory = isSelected ? null : category;
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.getDreamCategoryColor(category)
                          .withOpacity(0.2)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.getDreamCategoryColor(category)
                        : AppColors.borderLight,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppColors.getDreamCategoryColor(category)
                            : AppColors.textSecondaryLight,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _tagsController,
          decoration: const InputDecoration(
            hintText: 'flying, adventure, family (separate with commas)',
          ),
          onChanged: (value) {
            setState(() {
              _tags = value
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
            });
          },
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Text(
                  '#$tag',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSleepTimingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardPeach,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Timing',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Help improve your sleep analytics',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildTimeField(
                      'Bedtime', _bedTime, (time) => _bedTime = time)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildTimeField(
                      'Wake Time', _wakeTime, (time) => _wakeTime = time)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(
      String label, DateTime? time, Function(DateTime?) onTimeSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectTime(time, onTimeSelected),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: AppColors.textSecondaryLight),
                const SizedBox(width: 8),
                Text(
                  time != null
                      ? DateFormat('h:mm a').format(time)
                      : 'Tap to set',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dream Ratings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        _buildRatingSlider(
          'Mood',
          _moodRating,
          1,
          7,
          AppConstants.moodLabels[_moodRating - 1],
          AppColors.getMoodColor(_moodRating),
          (value) => setState(() => _moodRating = value),
        ),
        const SizedBox(height: 20),
        _buildRatingSlider(
          'Sleep Quality',
          _sleepQuality,
          1,
          5,
          AppConstants.sleepQualityLabels[_sleepQuality - 1],
          AppColors.getSleepQualityColor(_sleepQuality),
          (value) => setState(() => _sleepQuality = value),
        ),
        const SizedBox(height: 20),
        _buildRatingSlider(
          'Lucidity Level',
          _lucidityLevel,
          0,
          4,
          AppConstants.lucidityLevels[_lucidityLevel],
          AppColors.getLucidityColor(_lucidityLevel),
          (value) => setState(() => _lucidityLevel = value),
        ),
        const SizedBox(height: 20),
        _buildRatingSlider(
          'Dream Vividness',
          _dreamVividness ?? 3,
          1,
          5,
          _dreamVividness != null
              ? [
                  'Very Vague',
                  'Vague',
                  'Moderate',
                  'Vivid',
                  'Extremely Vivid'
                ][_dreamVividness! - 1]
              : 'Moderate',
          AppColors.primary,
          (value) => setState(() => _dreamVividness = value),
        ),
      ],
    );
  }

  Widget _buildRatingSlider(
    String label,
    int value,
    int min,
    int max,
    String displayLabel,
    Color color,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                displayLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
          ),
          child: Slider(
            value: value.toDouble(),
            min: min.toDouble(),
            max: max.toDouble(),
            divisions: max - min,
            onChanged: (newValue) => onChanged(newValue.round()),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveDream,
        child: _isSaving
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Saving...'),
                ],
              )
            : Text(widget.dreamToEdit != null ? 'Update Dream' : 'Save Dream'),
      ),
    );
  }

  Future<void> _selectTime(
      DateTime? currentTime, Function(DateTime?) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime != null
          ? TimeOfDay.fromDateTime(currentTime)
          : TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      onTimeSelected(selectedTime);
      setState(() {});
    }
  }

  Future<void> _saveDream() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final dream = widget.dreamToEdit?.copyWith(
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            category: _selectedCategory,
            moodRating: _moodRating,
            sleepQuality: _sleepQuality,
            lucidityLevel: _lucidityLevel,
            tags: _tags,
            isFavorite: _isFavorite,
            bedTime: _bedTime,
            wakeTime: _wakeTime,
            dreamVividness: _dreamVividness,
          ) ??
          Dream.create(
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            dreamDate: _dreamDate,
            category: _selectedCategory,
            moodRating: _moodRating,
            sleepQuality: _sleepQuality,
            lucidityLevel: _lucidityLevel,
            tags: _tags,
            isFavorite: _isFavorite,
            bedTime: _bedTime,
            wakeTime: _wakeTime,
            dreamVividness: _dreamVividness,
          );

      if (widget.dreamToEdit != null) {
        await ref.read(dreamsProvider.notifier).updateDream(dream);
      } else {
        await ref.read(dreamsProvider.notifier).addDream(dream);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.dreamToEdit != null
                ? 'Dream updated successfully!'
                : 'Dream saved successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving dream: $error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
