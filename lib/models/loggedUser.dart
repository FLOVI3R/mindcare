class loggedUser {
  final int id;
  final String token;
  final String name;
  final String type;
  final int deleted;

  const loggedUser({
    required this.id,
    required this.token,
    required this.name,
    required this.type,
    required this.deleted,
  });

  factory loggedUser.fromJson(Map<String, dynamic> json) {
    return loggedUser(
      token: json['token'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      deleted: json['deleted'] as int,
    );
  }
}
