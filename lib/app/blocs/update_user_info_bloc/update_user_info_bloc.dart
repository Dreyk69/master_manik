import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc
    extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;

  UpdateUserInfoBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UpdateUserInfoInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadProcess());
      try {
        String userImage = await _userRepository.uploadPicture(event.file, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadFailure());
      }
    });
    on<UploadListPicture>((event, emit) async {
      emit(UploadProcess());
      try {
        List<dynamic> updateListPhoto = await _userRepository.uploadListPicture(event.file, event.userId);
        emit(UploadListPictureSuccess(updateListPhoto));
      } catch (e) {
        emit(UploadFailure());
      }
    });
    
    on<UploadListUslug>((event, emit) async {
      emit(UploadProcess());
      try {
        List<Map<String, int>> updateListUslug = await _userRepository.uploadListUslug(event.usluga, event.cena, event.userId);
        emit(UploadListUslugSuccess(updateListUslug));
      } catch (e) {
        emit(UploadFailure());
      }
    });
  }
}
