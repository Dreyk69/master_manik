import 'dart:async';

import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(const AuthState.unknown()) {
    _userSubscription = userRepository.user.listen((authUser) {
      add(AuthUserChanged(authUser));
    });

    on<AuthUserChanged>((event, emit) {
      var user = event.user;
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
