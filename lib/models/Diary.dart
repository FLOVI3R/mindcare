class Diary {
  final int id;
  final String type;
  final String name;
  final String description;
  final String date;
  final String image;
  final String created_at;

  const Diary(
      {required this.id,
      required this.type,
      required this.name,
      required this.description,
      required this.date,
      required this.image,
      required this.created_at});

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json['id'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      image: json['image'] as String,
      created_at: json['created_at'] as String,
    );
  }
}
