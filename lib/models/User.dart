class User {
  final int id;
  final String token;
  final String name;
  final String type;
  final bool deleted;

  const User({
    required this.id,
    required this.token,
    required this.name,
    required this.type,
    required this.deleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      token: json['token'] as String,
      name: json['name'] as String,
      type: json['tye'] as String,
      deleted: json['deleted'] as bool,
    );
  }
}
