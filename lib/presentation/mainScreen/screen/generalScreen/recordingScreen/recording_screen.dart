import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class RecordingScreen extends StatelessWidget {
  RecordingScreen({super.key});
  final DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Ananasik Nails'),
            backgroundColor: const Color.fromARGB(255, 254, 199, 236),
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
            const Column(
              children: [
                Card(
                    color: Color.fromARGB(255, 252, 227, 248),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Запись на 17.04.2024 на 14:00'),
                            Text('Клиент: Кузнецова Анастасия Иванова'),
                            Text('Почта клиента: testpochtaklient1@mail.ru'),
                            Text('Услуга: Аппаратный маникюр. Цена: 2000р'),
                          ]),
                    ))
              ],
            ),
            Column(
              children: [
                TableCalendar(
                  rowHeight: 43,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  availableGestures: AvailableGestures.all,
                  focusedDay: today,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                )
              ],
            )
          ])),
    );
  }
}

//  title: Text('Ananasik Nails'),
//  backgroundColor: Color.fromARGB(255, 254, 199, 236),
