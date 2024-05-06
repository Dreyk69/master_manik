part of 'identification_bloc.dart';

sealed class IdentificationEvent extends Equatable {
  const IdentificationEvent();

  @override
  List<Object> get props => [];
}

class IdentificationUser extends IdentificationEvent {
  final User? user;
  const IdentificationUser(this.user);
}
