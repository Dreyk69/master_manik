import 'package:equatable/equatable.dart';

import '../entities/manicurist_entities.dart';

// ignore: must_be_immutable
class MyManicurist extends Equatable {
  final String id;
  final String email;
  final String name;
  String? avatar;
  final List<String> photoRabot;
  final List<Map<String, int>> uslugi;

  MyManicurist({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.photoRabot,
    required this.uslugi,
  });

  static MyManicurist empty = MyManicurist(
    id: '',
    email: '',
    name: '',
    avatar: '',
    photoRabot: [''],
    uslugi: [{}],
  );

  MyManicurist copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    List<String>? photoRabot,
    List<Map<String, int>>? uslugi,
  }) {
    return MyManicurist(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      photoRabot: photoRabot ?? this.photoRabot,
      uslugi: uslugi ?? this.uslugi,
    );
  }

  bool get isEmpty => this == MyManicurist.empty;

  bool get isNotEmpty => this != MyManicurist.empty;

  MyManicuristEntity toEntity() {
    return MyManicuristEntity(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      photoRabot: photoRabot,
      uslugi: uslugi,
    );
  }

  static MyManicurist fromEntity(MyManicuristEntity entity) {
    return MyManicurist(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar,
      photoRabot: entity.photoRabot,
      uslugi: entity.uslugi,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, name, avatar, photoRabot, uslugi];
}