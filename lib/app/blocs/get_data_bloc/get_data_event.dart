part of 'get_data_bloc.dart';

sealed class GetDataEvent extends Equatable {
  const GetDataEvent();

  @override
  List<Object> get props => [];
}

class GetDataUser extends GetDataEvent {
  final User? user;
  const GetDataUser(this.user);
}
class GetDataZapisUser extends GetDataEvent {
  final User? user;
  const GetDataZapisUser(this.user);
}
