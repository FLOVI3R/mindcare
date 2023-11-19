class User {
  final int id;
  final String name;
  final String email;
  final String type;
  final int email_confirmed;
  final int actived;
  final int deleted;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.email_confirmed,
    required this.actived,
    required this.deleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      type: json['type'] as String,
      email_confirmed: json['email_confirmed'] as int,
      actived: json['actived'] as int,
      deleted: json['deleted'] as int,
    );
  }
}
