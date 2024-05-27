import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../app/blocs/get_data_bloc/get_data_bloc.dart';
import '../../../../../app/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:intl/intl.dart';

class RecordingManicuristScreen extends StatefulWidget {
  const RecordingManicuristScreen({super.key});

  @override
  State<RecordingManicuristScreen> createState() =>
      _RecordingManicuristScreenState();
}

class _RecordingManicuristScreenState extends State<RecordingManicuristScreen> {
  final DateTime today = DateTime.now();
  DateTime? dateZapis;
  String timeZapis = '';
  String usluga = '';
  int? price;
  String name = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    bool _signInRequired = false;
    List<Map<String, dynamic>>? dataUserZapis;
    return BlocProvider(
        create: (userRepositoryContext) => GetDataBloc(
            myUserRepository:
                userRepositoryContext.read<AuthBloc>().userRepository),
        child: BlocBuilder<GetDataBloc, GetDataState>(
            builder: (getDataContext, state) {
          if (state is GetDataZapisInitial) {
            _signInRequired = false;
          } else if (state is GetDataZapisProcess) {
            _signInRequired = true;
          } else if (state is GetDataZapisSuccess) {
            if (state.zapis != null) {
              dataUserZapis = state.zapis;
              _signInRequired = false;
            }
          } else if (state is GetDataZapisFailure) {
            _signInRequired = false;
          }
          return !_signInRequired
              ? DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Scaffold(
                      appBar: AppBar(
                        title: const Text('Ananasik Nails'),
                        backgroundColor:
                            const Color.fromARGB(255, 254, 199, 236),
                        bottom: const TabBar(tabs: <Widget>[
                          Tab(
                            icon: Icon(Icons.edit),
                          ),
                          Tab(
                            icon: Icon(Icons.calendar_month),
                          ),
                        ]),
                      ),
                      body: TabBarView(children: [
                        ListView.builder(
                          itemBuilder: (context, index) {
                            Map<String, dynamic> postMap =
                                dataUserZapis![index];
                            dateZapis = postMap['dateZapis'].toDate();
                            String date = DateFormat('dd-MM').format(dateZapis!);
                            timeZapis = postMap['timeZapis'];
                            usluga = postMap['usluga'];
                            price = postMap['price'];
                            name = postMap['nameClient'];
                            email = postMap['emailClient'];
                            return Card(
                                color: Color.fromARGB(255, 252, 227, 248),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Запись на $date на $timeZapis'),
                                        Text('Клиент: $name'),
                                        Text('Почта клиента: $email'),
                                        Text('Услуга: $usluga. Цена: $priceр'),
                                      ]),
                                ));
                          },
                          itemCount: dataUserZapis?.length ?? 0,
                        ),
                        const CalendarWidgetScreen()
                      ])))
              : const Center(child: CircularProgressIndicator());
        }));
  }
}

class CalendarWidgetScreen extends StatefulWidget {
  const CalendarWidgetScreen({
    super.key,
  });

  @override
  State<CalendarWidgetScreen> createState() => _CalendarWidgetScreenState();
}

class _CalendarWidgetScreenState extends State<CalendarWidgetScreen> {
  bool _zapisiRequired = false;
  Map<String, dynamic>? dataUser;
  bool _signInRequired = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime? _selectedDay;

  Map<DateTime, List<String>> events = {};
  dynamic prohodnoyEvent;

  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (userRepositoryContext) => GetDataBloc(
            myUserRepository:
                userRepositoryContext.read<AuthBloc>().userRepository),
        child: BlocBuilder<GetDataBloc, GetDataState>(
            builder: (getDataContext, state) {
          if (state is GetDataInitial) {
            _signInRequired = false;
          } else if (state is GetDataProcess) {
            _signInRequired = true;
          } else if (state is GetDataSuccess) {
            _signInRequired = false;
            if (state.client != null) {
              var client = state.client;
              dataUser = client;
            } else {
              var manicurist = state.manicurist;
              dataUser = manicurist;
            }
          } else if (state is GetDataFailure) {
            _signInRequired = false;
          }
          if (dataUser?['okohki'] != null) {
            prohodnoyEvent = dataUser?['okohki'];
            prohodnoyEvent.forEach((key, value) {
              DateTime date = DateTime.parse(key);
              List<String> eventList = List<String>.from(value);
              events[date] = eventList;
            });
            _zapisiRequired = false;
          } else {
            _zapisiRequired = true;
          }
          return BlocProvider(
              create: (userRepositoryContext) => UpdateUserInfoBloc(
                  userRepository:
                      userRepositoryContext.read<AuthBloc>().userRepository),
              child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
                  builder: (updateUserInfoContext, state) {
                if (state is UploadListOkohekSuccess) {
                  events = state.updateListOkohek;
                  _zapisiRequired = false;
                }
                return Scaffold(
                    floatingActionButton: FloatingActionButton.extended(
                      label: const Text('Добавить запись'),
                      onPressed: () => _openAddEventDialog(
                          updateUserInfoContext: updateUserInfoContext,
                          id: dataUser?['id']),
                    ),
                    body: !_signInRequired
                        ? Column(
                            children: [
                              TableCalendar(
                                rowHeight: 43,
                                headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true),
                                availableGestures: AvailableGestures.all,
                                focusedDay: _focusedDay,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                calendarFormat: _calendarFormat,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay =
                                        focusedDay; // update `_focusedDay` here as well
                                  });
                                },
                                onFormatChanged: (format) {
                                  if (_calendarFormat != format) {
                                    setState(() {
                                      _calendarFormat = format;
                                    });
                                  }
                                },
                                eventLoader: (day) {
                                  return events[day] ?? [];
                                },
                              ),
                              !_zapisiRequired && events[_selectedDay] != null
                                  ? Expanded(
                                      child: ListView.builder(
                                      itemCount: events[_selectedDay]?.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                            color: Color.fromARGB(
                                                255, 252, 227, 248),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 10),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Запись на ${events[_selectedDay]?[index]}'),
                                                    Text('Статус: Свободна'),
                                                  ]),
                                            ));
                                      },
                                    ))
                                  : const Card(
                                      color: Color.fromARGB(255, 252, 227, 248),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text('Записей нету'),
                                              )
                                            ]),
                                      ))
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()));
              }));
        }));
  }

  Future<void> _openAddEventDialog(
      {required BuildContext updateUserInfoContext, required String id}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final String formattedTime = pickedTime.format(context);
      setState(() {
        if (_selectedDay != null) {
          DateTime selectedDay = _selectedDay!;
          updateUserInfoContext
              .read<UpdateUserInfoBloc>()
              .add(UploadListOkohek(selectedDay, formattedTime, id));
        } else {
          updateUserInfoContext
              .read<UpdateUserInfoBloc>()
              .add(UploadListOkohek(_focusedDay, formattedTime, id));
        }
      });
    }
  }
}



//  title: Text('Ananasik Nails'),
//  backgroundColor: Color.fromARGB(255, 254, 199, 236),
