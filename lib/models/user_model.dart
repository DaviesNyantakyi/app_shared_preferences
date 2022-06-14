import 'dart:convert';

class UserModel {
  final String name;
  final String hobby;
  final String food;
  UserModel({
    required this.name,
    required this.hobby,
    required this.food,
  });

  UserModel copyWith({
    String? name,
    String? hobby,
    String? food,
  }) {
    return UserModel(
      name: name ?? this.name,
      hobby: hobby ?? this.hobby,
      food: food ?? this.food,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'hobby': hobby,
      'food': food,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      hobby: map['hobby'] as String,
      food: map['food'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserData(name: $name, hobby: $hobby, food: $food)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.hobby == hobby &&
        other.food == food;
  }

  @override
  int get hashCode => name.hashCode ^ hobby.hashCode ^ food.hashCode;
}
