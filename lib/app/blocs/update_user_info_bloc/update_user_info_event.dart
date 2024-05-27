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

class UploadListOkohek extends UpdateUserInfoEvent {
  final DateTime day;
  final String formattedTime;
  final String userId;

  const UploadListOkohek(
    this.day,
    this.formattedTime,
    this.userId,
  );

  @override
  List<Object> get props => [day, formattedTime, userId];
}

class NewZapis extends UpdateUserInfoEvent {
  final String masterId;
  final String userId;
  final DateTime selectedDate;
  final String selectedTime;
  final String selectedService;
  final int selectedPrice;
  final String nameUser;
  final String emailUser;
  final String nameMaster;
  final String emailMaster;

  const NewZapis({
    required this.masterId,
    required this.userId,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedService,
    required this.selectedPrice,
    required this.nameUser,
    required this.emailUser,
    required this.nameMaster,
    required this.emailMaster,
  });

  @override
  List<Object> get props => [
        masterId,
        userId,
        selectedDate,
        selectedTime,
        selectedService,
        selectedPrice,
        nameUser,
        emailUser,
        nameMaster,
        emailMaster
      ];
}
