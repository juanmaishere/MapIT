// Modelo de datos para representar un usuario
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? createdAt;
  final String? updatedAt;

  //Constructor
  const UserModel(
    {
      required this.id,
      this.email,
      this.name,
      this.createdAt,
      this.updatedAt
    }
  );

  static const empty = UserModel(id: '');

  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [id, email, name, createdAt, updatedAt];
}