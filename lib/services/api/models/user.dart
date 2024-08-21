class User {
  final int id;
  final String name;
  final String email;
  final int age;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'isActive': isActive,
    };
  }
}

class CreateUserInput {
  final String name;
  final String email;
  final int age;

  CreateUserInput({
    required this.name,
    required this.email,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
    };
  }
}

class UpdateUserInput {
  final String? name;
  final String? email;
  final int? age;
  final bool? isActive;

  UpdateUserInput({
    this.name,
    this.email,
    this.age,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (isActive != null) 'isActive': isActive,
    };
  }
}
