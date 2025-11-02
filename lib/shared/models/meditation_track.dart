class MeditationTrack {
  final String id;
  final String title;
  final String description;
  final String level;
  final String image;
  final String video;
  final String type;
  final String category;
  final bool isPremium;
  final bool isPlaying;

  MeditationTrack({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.image,
    required this.video,
    required this.type,
    required this.category,
    required this.isPremium,
    required this.isPlaying,
  });

  factory MeditationTrack.fromJson(Map<String, dynamic> json) {
    return MeditationTrack(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      level: json['level'] as String,
      image: json['image'] as String,
      video: json['video'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      isPremium: json['isPremium'] as bool,
      isPlaying: json['isPlaying'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'level': level,
      'image': image,
      'video': video,
      'type': type,
      'category': category,
      'isPremium': isPremium,
      'isPlaying': isPlaying,
    };
  }
}

