
part of 'identification_bloc.dart';

sealed class IdentificationState {
}

final class IdentificationInitial extends IdentificationState {}

final class IdentificationClient extends IdentificationState {}

final class IdentificationManicurist extends IdentificationState {}

final class IdentificationFailure extends IdentificationState {}
