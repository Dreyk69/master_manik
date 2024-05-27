import 'package:ananasik_nails/app/blocs/identification_bloc/identification_bloc.dart';
import 'package:ananasik_nails/app/blocs/post_bloc/post_bloc.dart';
import 'package:ananasik_nails/domain/repository/post_repository/lib/post_repository.dart';
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
  final PostRepository postRepository;
  const Application(this.userRepository, this.postRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthBloc>(
              create: (_) => AuthBloc(
                  myUserRepository: userRepository,
                  myPostRepository: postRepository)),
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
            BlocProvider<PostBloc>(
                create: (_) =>
                    PostBloc(myPostRepository: postRepository)),
          ],
          child: ApplicationView(),
        ));
  }
}
