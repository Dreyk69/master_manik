import 'package:ananasik_nails/presentation/mainScreen/screen/clientScreen/profileClientScreen/profile_client_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/styles/colors.dart';
import '../domain/logic/application_logic.dart';
import '../infrastructure/navigation_service.dart';
import '../presentation/auth_and_registration/authScreen/auth_screen.dart';
import '../presentation/auth_and_registration/registrationScreen/registration_screen.dart';
import '../presentation/mainScreen/main_screen.dart';
import '../presentation/mainScreen/screen/manicuristScreen/profileManicuristScreen/profile_manicurist_screen.dart';
import '../presentation/not_found_screen.dart';
import 'blocs/auth_bloc/auth_bloc.dart';

class ApplicationView extends StatelessWidget {
  final navigationService = AppInitializer.getIt<NavigationService>();
  ApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Ananasik Nails',
      theme: ThemeData(
          primaryColor: mainColor,
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          useMaterial3: true),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return const MainScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RegistrationWidget.routeName:
            return MaterialPageRoute(
                builder: (context) => const RegistrationWidget());
          case MainScreen.routeName:
            return MaterialPageRoute(builder: (context) => const MainScreen());
          case ProfileClientScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => ProfileClientScreen());
          case ProfileManicuristScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => const ProfileManicuristScreen());
          case NotFoundScreen.routeName:
            return MaterialPageRoute(
                builder: (context) => const NotFoundScreen());
          default:
            return MaterialPageRoute(
                builder: (context) => const NotFoundScreen());
        }
      },
    );
  }
}
