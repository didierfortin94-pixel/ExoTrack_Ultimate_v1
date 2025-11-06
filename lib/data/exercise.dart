
class Exercise {
  final String id;
  final String name;
  final List<String> tags;
  final String? youtubeUrl;
  final String loadType; // %1RM | RPE | Velocity
  const Exercise({required this.id, required this.name, required this.tags, this.youtubeUrl, required this.loadType});
}
