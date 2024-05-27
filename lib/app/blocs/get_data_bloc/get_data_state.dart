part of 'get_data_bloc.dart';

sealed class GetDataState extends Equatable {
  const GetDataState();

  @override
  List<Object> get props => [];
}

final class GetDataInitial extends GetDataState {}

final class GetDataSuccess extends GetDataState {
  final Map<String, dynamic>? client;
  final Map<String, dynamic>? manicurist;

  const GetDataSuccess({this.client, this.manicurist});
}

final class GetDataFailure extends GetDataState {}

final class GetDataProcess extends GetDataState {}

final class GetDataZapisInitial extends GetDataState {}

final class GetDataZapisSuccess extends GetDataState {
  final List<Map<String, dynamic>>? zapis;

  const GetDataZapisSuccess({this.zapis});
}

final class GetDataZapisFailure extends GetDataState {}

final class GetDataZapisProcess extends GetDataState {}
