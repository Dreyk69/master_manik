part of 'identification_bloc.dart';

sealed class IdentificationState extends Equatable {
   const IdentificationState();

  @override
  List<Object> get props => [];
}

final class IdentificationInitial extends IdentificationState {}

final class IdentificationClient extends IdentificationState {
  final String id;

  const IdentificationClient(this.id);
  
  @override
  List<Object> get props => [id];
}

final class IdentificationManicurist extends IdentificationState {
  final String id;

  const IdentificationManicurist(this.id);
  
  @override
  List<Object> get props => [id];
}

final class IdentificationFailure extends IdentificationState {}
