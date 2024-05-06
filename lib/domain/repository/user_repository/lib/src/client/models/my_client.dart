import 'package:equatable/equatable.dart';

import '../entities/client_entities.dart';

class MyClient extends Equatable {
  final String id;
  final String email;
  final String name;

  const MyClient({
    required this.id,
    required this.email,
    required this.name,
  });

  static const empty = MyClient(
    id: '',
    email: '',
    name: '',
  );

  MyClient copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return MyClient(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  bool get isEmpty => this == MyClient.empty;

  bool get isNotEmpty => this != MyClient.empty;

  MyClientEntity toEntity() {
    return MyClientEntity(
      id: id,
      email: email,
      name: name,
    );
  }

  static MyClient fromEntity(MyClientEntity entity) {
    return MyClient(
      id: entity.id,
      email: entity.email,
      name: entity.name,
    );
  }

  @override
  List<Object?> get props => [id, email, name];
}
