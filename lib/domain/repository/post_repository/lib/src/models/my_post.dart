import 'package:equatable/equatable.dart';

import '../entities/post_entities.dart';

// ignore: must_be_immutable
class MyPost extends Equatable {
  final String id;
  final String email;
  final String name;
  String? avatar;
  List<String> photoRabot;
  List<Map<String, int>> uslugi;
  Map<String, dynamic> okohki;

  MyPost({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.photoRabot,
    required this.uslugi,
    required this.okohki,
  });

  static MyPost empty = MyPost(
    id: '',
    email: '',
    name: '',
    avatar: '',
    photoRabot: [''],
    uslugi: [{}],
    okohki: {},
  );

  MyPost copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    List<String>? photoRabot,
    List<Map<String, int>>? uslugi,
    Map<String, dynamic>? okohki,
  }) {
    return MyPost(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      photoRabot: photoRabot ?? this.photoRabot,
      uslugi: uslugi ?? this.uslugi,
      okohki: okohki ?? this.okohki,
    );
  }

  bool get isEmpty => this == MyPost.empty;

  bool get isNotEmpty => this != MyPost.empty;

  MyPostEntity toEntity() {
    return MyPostEntity(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
      photoRabot: photoRabot,
      uslugi: uslugi,
      okohki: okohki,
    );
  }

  static MyPost fromEntity(MyPostEntity entity) {
    return MyPost(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      avatar: entity.avatar,
      photoRabot: entity.photoRabot,
      uslugi: entity.uslugi,
      okohki: entity.okohki,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, name, avatar, photoRabot, uslugi, okohki];
}