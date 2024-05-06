import 'dart:developer';

import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc({required UserRepository myUserRepository})
      : _userRepository = myUserRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      if (event.client != null) {
        try {
          MyClient client = await _userRepository.signUpForClient(
              event.client!, event.password);
          await _userRepository.setClientData(client);
          emit(SignUpSuccess());
        } catch (e) {
          log(e.toString());
          emit(SignUpFailure());
        }
      } else if (event.manicurist != null) {
        try {
          MyManicurist manicurist = await _userRepository.signUpForManicurist(
              event.manicurist!, event.password);
          await _userRepository.setManicuristData(manicurist);
          emit(SignUpSuccess());
        } catch (e) {
          log(e.toString());
          emit(SignUpFailure());
        }
      }
    });
  }
}
