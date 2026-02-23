enum ExerciseCategory { strength, power, plyo, conditioning, mobility, rehab }

class Exercise {
  const Exercise({
    required this.id,
    required this.coachId,
    required this.name,
    required this.category,
    required this.equipment,
    this.tags = const [],
    required this.instructions,
    this.coachingCues = const [],
    this.mediaUrl,
    this.imagePath,
    this.shared = false,
  });

  final String id;
  final String coachId;
  final String name;
  final ExerciseCategory category;
  final String equipment;
  final List<String> tags;
  final String instructions;
  final List<String> coachingCues;
  final String? mediaUrl;
  final String? imagePath;
  final bool shared;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        coachId: json['coach_id'] as String,
        name: json['name'] as String,
        category: ExerciseCategory.values.byName(json['category'] as String),
        equipment: json['equipment'] as String,
        tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
        instructions: json['instructions'] as String,
        coachingCues: (json['coaching_cues'] as List<dynamic>? ?? []).cast<String>(),
        mediaUrl: json['media_url'] as String?,
        imagePath: json['image_path'] as String?,
        shared: json['shared'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'coach_id': coachId,
        'name': name,
        'category': category.name,
        'equipment': equipment,
        'tags': tags,
        'instructions': instructions,
        'coaching_cues': coachingCues,
        'media_url': mediaUrl,
        'image_path': imagePath,
        'shared': shared,
      };
}
