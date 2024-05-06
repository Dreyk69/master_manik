import 'package:equatable/equatable.dart';

class MyClientEntity extends Equatable {
  final String id;
  final String email;
  final String name;

  const MyClientEntity({
    required this.id,
    required this.email,
    required this.name,
  });

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  static MyClientEntity fromDocument(Map<String, dynamic> doc) {
    return MyClientEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, email, name];

  @override
  String toString() {
    return '''ClientEntity: {
      id: $id
      email: $email
      name: $name
    }''';
  }
}
