import 'package:ananasik_nails/constants/private_variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../infrastructure/navigation_service.dart';
import '../../infrastructure/simple_bloc_observer.dart';

class AppInitializer {
  static final GetIt getIt = GetIt.instance;

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket,
    )
    );

    getIt.registerSingleton<NavigationService>(NavigationService());
    Bloc.observer = SimpleBlocObserver();
    getIt.registerSingleton<SimpleBlocObserver>(SimpleBlocObserver());

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
