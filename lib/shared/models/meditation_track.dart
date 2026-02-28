import '../../core/constants/app_constants.dart';

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
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? 'A',
      image: json['image'] as String? ?? '',
      video: json['video'] as String? ?? '',
      type: json['type'] as String? ?? 'meditation',
      category: json['category'] as String? ?? 'relaxation',
      isPremium: json['isPremium'] as bool? ?? false,
      isPlaying: json['isPlaying'] as bool? ?? false,
    );
  }

  /// Из ответа API контента (ContentTrack + section.slug как category).
  factory MeditationTrack.fromApiJson(Map<String, dynamic> json, {required String category}) {
    final base = AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
    String image = json['coverUrl'] as String? ?? '';
    if (image.isNotEmpty && !image.startsWith('http')) image = '$base$image';
    String video = json['audioUrl'] as String? ?? '';
    if (video.isNotEmpty && !video.startsWith('http')) video = '$base$video';
    return MeditationTrack(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['descriptionShort'] as String? ?? '',
      level: json['level'] as String? ?? 'A',
      image: image,
      video: video,
      type: 'meditation',
      category: category,
      isPremium: json['isPremium'] as bool? ?? false,
      isPlaying: false,
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

