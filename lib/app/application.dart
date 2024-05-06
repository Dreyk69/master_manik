import 'package:ananasik_nails/app/blocs/identification_bloc/identification_bloc.dart';
import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'application_view.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/get_data_bloc/get_data_bloc.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';
import 'blocs/sign_up_bloc/sign_up_bloc.dart';
import 'blocs/update_user_info_bloc/update_user_info_bloc.dart';

class Application extends StatelessWidget {
  final UserRepository userRepository;
  const Application(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthBloc>(
              create: (_) => AuthBloc(myUserRepository: userRepository))
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<SignInBloc>(
                create: (_) => SignInBloc(myUserRepository: userRepository)),
            BlocProvider<SignUpBloc>(
                create: (_) => SignUpBloc(myUserRepository: userRepository)),
            BlocProvider<GetDataBloc>(
                create: (_) => GetDataBloc(myUserRepository: userRepository)),
            BlocProvider<UpdateUserInfoBloc>(
                create: (_) =>
                    UpdateUserInfoBloc(userRepository: userRepository)),
            BlocProvider<IdentificationBloc>(
                create: (_) =>
                    IdentificationBloc(myUserRepository: userRepository)),
// RepositoryProvider почитать про него поподробнее
          ],
          child: ApplicationView(),
        ));
  }
}
