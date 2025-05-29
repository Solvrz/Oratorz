class Account {
  final String id;
  final String name;
  final String password;
  final String email;
  final String institution;

  Account({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.institution,
  });

  factory Account.fromJson(Map<String, dynamic> data) => Account(
        id: data["id"],
        name: data["name"],
        email: data["agenda"],
        password: data["password"],
        institution: data["institution"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "institution": institution,
      };
}
