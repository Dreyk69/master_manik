part of 'update_user_info_bloc.dart';

sealed class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();

  @override
  List<Object> get props => [];
}

final class UpdateUserInfoInitial extends UpdateUserInfoState {}

class UploadPictureSuccess extends UpdateUserInfoState {
  final String userImage;

  const UploadPictureSuccess(this.userImage);

  @override
  List<Object> get props => [userImage];
}

class UploadListPictureSuccess extends UpdateUserInfoState {
  final  List<dynamic> updateListPhoto;

  const UploadListPictureSuccess(this.updateListPhoto);

  @override
  List<Object> get props => [updateListPhoto];
}

class UploadListUslugSuccess extends UpdateUserInfoState {
  final List<Map<String, int>> updateListUslug;

  const UploadListUslugSuccess(this.updateListUslug);

  @override
  List<Object> get props => [updateListUslug];
}

class UploadListOkohekSuccess extends UpdateUserInfoState {
  final Map<DateTime, List<String>> updateListOkohek;

  const UploadListOkohekSuccess(this.updateListOkohek);

  @override
  List<Object> get props => [updateListOkohek];
}

class UploadFailure extends UpdateUserInfoState {}

class UploadProcess extends UpdateUserInfoState {}
