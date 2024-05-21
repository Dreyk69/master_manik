part of 'update_user_info_bloc.dart';

sealed class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserInfoEvent {
  final String file;
  final String userId;

  const UploadPicture(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}

class UploadListPicture extends UpdateUserInfoEvent {
  final String file;
  final String userId;

  const UploadListPicture(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}

class UploadListUslug extends UpdateUserInfoEvent {
  final String usluga;
  final String cena;
  final String userId;

  const UploadListUslug(this.usluga, this.cena, this.userId);

  @override
  List<Object> get props => [usluga, cena, userId];
}
