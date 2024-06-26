import 'package:equatable/equatable.dart';

class MyManicuristEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final List<String>? photoRabot;
  final List<Map<String, int>>? uslugi;
  final Map<DateTime, List<String>>? okohki;

  const MyManicuristEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.photoRabot,
    this.uslugi,
    this.okohki,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'photoRabot': photoRabot,
      'uslugi': uslugi,
      'okohki': okohki,
    };
  }

  static MyManicuristEntity fromDocument(Map<String, dynamic> doc) {
    return MyManicuristEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      avatar: doc['avatar'] as String?,
      photoRabot: doc['photoRabot'] as List<String>?,
      uslugi: doc['uslugi'] as List<Map<String, int>>?,
      okohki: doc['okohki'] as Map<DateTime, List<String>>?,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, name, avatar, photoRabot, uslugi, okohki];

  @override
  String toString() {
    return '''ManicuristEntity: {
      id: $id
      email: $email
      name: $name
      avatar: $avatar
      photoRabot: $photoRabot
      uslugi: $uslugi
      okohki: $okohki
    }''';
  }
}
