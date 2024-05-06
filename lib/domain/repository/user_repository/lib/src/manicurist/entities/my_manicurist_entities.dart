import 'package:equatable/equatable.dart';

class MyManicuristEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final List<String> photoRabot;
  final List<String> uslugi;
  final List<int> cena;

  const MyManicuristEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    required this.photoRabot,
    required this.uslugi,
    required this.cena,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'photoRabot': photoRabot,
      'uslugi': uslugi,
      'cena': cena,
    };
  }

  static MyManicuristEntity fromDocument(Map<String, dynamic> doc) {
    return MyManicuristEntity(
      id: doc['id'] as String,
      email: doc['email'] as String,
      name: doc['name'] as String,
      avatar: doc['avatar'] as String?,
      photoRabot: doc['photoRabot'] as List<String>,
      uslugi: doc['uslugi'] as List<String>,
      cena: doc['cena'] as List<int>,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, name, avatar, photoRabot, uslugi, cena];

  @override
  String toString() {
    return '''ManicuristEntity: {
      id: $id
      email: $email
      name: $name
      avatar: $avatar
      photoRabot: $photoRabot
      uslugi: $uslugi
      cena: $cena
    }''';
  }
}
