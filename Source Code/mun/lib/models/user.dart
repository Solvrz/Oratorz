class User {
  final String id;
  final String name;
  final String email;
  final num contactNo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
  });

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data["id"],
        name: data["name"],
        email: data["email"],
        contactNo: data["contactNo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "contactNo": contactNo,
      };

  bool isEqual(User user) => user.id == id;
}
