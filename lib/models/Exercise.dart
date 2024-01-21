class Exercise {
  final int id;
  final String name;
  final String improvement;
  final String type;
  final String explanation;
  final String image;
  final String audio;
  final String video;

  const Exercise(
      {required this.id,
      required this.name,
      required this.improvement,
      required this.type,
      required this.explanation,
      required this.image,
      required this.audio,
      required this.video});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
        id: json['id'] as int,
        name: json['name'] as String,
        improvement: json['improvement'] as String,
        type: json['type'] as String,
        explanation: json['explanation'] as String,
        image: json['image'] as String,
        audio: json['audio'] as String,
        video: json['video'] as String);
  }
}
