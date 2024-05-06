part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent {
  final MyClient? client;
  final MyManicurist? manicurist;
  final String password;

  const SignUpRequired({this.client, required this.password, this.manicurist});
}
