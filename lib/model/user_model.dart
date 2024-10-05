class UserModel {
  String id;
  String name;
  String email;
  String image;

  UserModel({required this.id, required this.name, required this.email, required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      email: json['email'] ?? 'No Email',
      image: json['image'] ?? 'No Image',
    );
  }
}





