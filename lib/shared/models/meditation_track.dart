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
  /// Длительность в секундах (для отображения "N мин" и totalTime в плеере).
  final int? durationSeconds;

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
    this.durationSeconds,
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
      durationSeconds: json['durationSeconds'] as int?,
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
      durationSeconds: json['durationSeconds'] as int?,
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
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
    };
  }

  /// Форматирует длительность для плеера, например "3:45".
  static String formatDuration(int? durationSeconds) {
    if (durationSeconds == null || durationSeconds <= 0) return '0:00';
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

