import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:flutter/material.dart';

import 'app/application.dart';
import 'domain/logic/application_logic.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(Application(FirebaseUserRepository()));
}
