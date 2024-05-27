import 'package:ananasik_nails/app/blocs/get_data_bloc/get_data_bloc.dart';
import 'package:ananasik_nails/app/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../constants/styles/icons.dart';

// ignore: must_be_immutable
class ZapisScreen extends StatefulWidget {
  ZapisScreen(this.post, {super.key});
  static const routeName = '/main/zapis_screen';
  Map<String, dynamic> post;

  @override
  // ignore: no_logic_in_create_state
  State<ZapisScreen> createState() => _ZapisScreenState(post);
}

class _ZapisScreenState extends State<ZapisScreen> {
  _ZapisScreenState(this.post);
  Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    List<dynamic> spisokUslugProverka = [];
    final String email = post['email'];
    final List<Map<String, int>> uslugi;
    final String name = post['name'];
    Map<DateTime, List<String>> events = {};
    dynamic prohodnoyEvent = post['okohki'];
    prohodnoyEvent.forEach((key, value) {
      DateTime date = DateTime.parse(key).toUtc();
      List<String> eventList = List<String>.from(value);
      events[date] = eventList;
    });
    final List<dynamic> photoRabot = post['photoRabot'];
    spisokUslugProverka = post['uslugi'];
    uslugi = spisokUslugProverka.map((item) {
      if (item is Map) {
        return item.map((key, value) => MapEntry(key.toString(), value as int));
      } else {
        return <String, int>{};
      }
    }).toList();

    final Image ava;
    if (post['avatar'] != '') {
      ava = Image.network(
        'assets/image/avatar.png',
        fit: BoxFit.cover,
      );
    } else {
      ava = Image.asset(
        'assets/image/avatar.png',
        fit: BoxFit.cover,
      );
    }
    // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //   Map<DateTime, List<String>> events1 = {
    //   DateTime(2024, 5, 26): ['15:00', '15:35', '16:15'],
    //   DateTime(2024, 5, 27): ['10:00', '11:00', '12:00']
    // };

    // List<Map<String, int>> uslugi1 = [
    //   {'Маникюр': 1000},
    //   {'Педикюр': 1200},
    //   {'Наращивание ногтей': 1500}
    // ];

    DateTime? selectedDate;
    String? selectedTime;
    String? selectedService;
    int? selectedPrice;
    String userId = '';
    String userEmail = '';
    String userName = '';
    void showConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Подтверждение записи'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Дата записи: ${selectedDate.toString().split(' ')[0]}'),
                Text('Время записи: $selectedTime'),
                Text('Услуга: $selectedService'),
                Text('Цена: $selectedPrice руб.'),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    context.read<UpdateUserInfoBloc>().add(NewZapis(
                          masterId: post['id'],
                          userId: userId,
                          selectedDate: selectedDate!,
                          selectedTime: selectedTime!,
                          selectedService: selectedService!,
                          selectedPrice: selectedPrice!,
                          nameUser: userName,
                          emailUser: userEmail,
                          nameMaster: name,
                          emailMaster: email,
                        ));
                  });
                },
                child: const Text('Подтвердить'),
              ),
            ],
          );
        },
      );
    }

    void showServicePickerDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Выберите услугу'),
                content: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedService,
                  hint: Text('Выберите услугу'), // Добавляем подсказку
                  items: uslugi
                      .map((service) => DropdownMenuItem<String>(
                            value: service.keys.first,
                            child: Text(service.keys.first),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedService = newValue;
                      selectedPrice = uslugi
                          .firstWhere(
                              (service) => service.keys.first == newValue)
                          .values
                          .first;
                    });
                  },
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (selectedService != null) {
                        Navigator.of(context).pop();
                        showConfirmationDialog();
                      }
                    },
                    child: Text('Продолжить'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    void showTimePickerDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Выберите время'),
                content: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedTime,
                  hint: Text('Выберите время'), // Добавляем подсказку
                  items: events[selectedDate]!
                      .map((time) => DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTime = newValue;
                    });
                  },
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (selectedTime != null) {
                        Navigator.of(context).pop();
                        showServicePickerDialog();
                      }
                    },
                    child: Text('Продолжить'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    // -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    return BlocBuilder<GetDataBloc, GetDataState>(builder: (context, state) {
      if (state is GetDataSuccess) {
        if (state.client != null) {
          var client = state.client;
          userId = client?['id'];
          userEmail = client?['email'];
          userName = client?['name'];
        } else if (state.manicurist != null) {
          var manicurist = state.client;
          userId = manicurist?['id'];
          userEmail = manicurist?['email'];
          userName = manicurist?['name'];
        }
      }
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 254, 199, 236),
            title: const Text('Ananasik Nails'),
          ),
          floatingActionButton: FloatingActionButton.extended(
              label: const Text('Записаться'),
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  DateTime pickedDateUtc = DateTime.utc(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                  );

                  if (events.containsKey(pickedDateUtc)) {
                    setState(() {
                      selectedDate = pickedDateUtc;
                    });
                    showTimePickerDialog();
                  }
                }
              }),
          body: ListView(
            controller: _scrollController,
            children: [
              Column(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 254, 199, 236)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 0),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          ClipOval(
                              child: SizedBox.fromSize(
                                  size: const Size.fromRadius(35), child: ava)),
                          const SizedBox(width: 15),
                          Text(name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                  ),
                  Stack(children: <Widget>[
                    SizedBox(
                        height: 150,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: CustomScrollView(
                              scrollDirection: Axis.horizontal,
                              slivers: <Widget>[
                                SliverList.builder(
                                    itemCount: photoRabot.length,
                                    itemBuilder: (context, index) =>
                                        Image.network(
                                          photoRabot[index],
                                          fit: BoxFit.fitHeight,
                                        ))
                              ],
                            )))
                  ]),
                  const SizedBox(height: 1),
                  SizedBox(
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Text('Показать все'),
                                  strelochkaIcon
                                ],
                              )),
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 20),
                      child: Row(
                        children: [
                          const Text('Email:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 20),
                          Text(email,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    color: Colors.black45,
                  ),
                  SizedBox(
                      child: Column(children: [
                    ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: uslugi.length,
                        itemBuilder: (context, index) {
                          Map<String, int> uslugaMap = uslugi[index];
                          String usluga = uslugaMap.keys.first;
                          int cena = uslugaMap.values.first;
                          return SizedBox(
                            height: 90,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      flex: 2,
                                      child: Text(
                                        '$usluga:',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  const SizedBox(width: 10),
                                  Text(
                                    '$cenaр',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 50)
                  ]))
                ],
              ),
            ],
          ));
    });
  }
}




            // DateTime? newData = await showDatePicker(
            //     context: context,
            //     initialDate: today,
            //     firstDate: DateTime(1900),
            //     lastDate: DateTime(2100));
            // if (newData == null) {
            //   return;
            // } else {
            //   // ignore: use_build_context_synchronously
            //   return showDialog(
            //       context: context,
            //       builder: (BuildContext context) => AlertDialog(
            //             title: const Text('Выбырите время и услугу'),
            //             content: Row(
            //               children: [
            //                 const SizedBox(
            //                   width: 20,
            //                 ),
            //                 DropdownButton<String>(
            //                   hint: const Center(
            //                       child: Text(
            //                     '',
            //                     style: TextStyle(color: Colors.white),
            //                   )),
            //                   value: _dropdownvalue1,
            //                   onChanged: (value) {
            //                     setState(() {
            //                       _dropdownvalue1 = value;
            //                     });
            //                   },
            //                   items: items1.map((e) {
            //                     return DropdownMenuItem(
            //                       value: e,
            //                       child: Text(
            //                         e,
            //                         style: const TextStyle(color: Colors.black),
            //                       ),
            //                     );
            //                   }).toList(),
            //                 ),
            //                 const SizedBox(
            //                   width: 20,
            //                 ),
            //                 SizedBox(
            //                   child: DropdownButton<String>(
            //                     hint: const Center(
            //                         child: Text(
            //                       '',
            //                       style: TextStyle(color: Colors.white),
            //                     )),
            //                     value: _dropdownvalue2,
            //                     onChanged: (value) {
            //                       setState(() {
            //                         _dropdownvalue2 = value;
            //                       });
            //                     },
            //                     items: items2.map((e) {
            //                       return DropdownMenuItem(
            //                         value: e,
            //                         child: SizedBox(
            //                           width: 150,
            //                           child: Flexible(
            //                             flex: 1,
            //                             child: Text(
            //                               overflow: TextOverflow.ellipsis,
            //                               maxLines: 1,
            //                               e,
            //                               style: const TextStyle(
            //                                   color: Colors.black),
            //                             ),
            //                           ),
            //                         ),
            //                       );
            //                     }).toList(),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //             actions: [
            //               TextButton(
            //                 onPressed: () {
            //                   // Действие при нажатии на кнопку
            //                   Navigator.of(context)
            //                       .pop(); // Закрываем AlertDialog
            //                 },
            //                 child: const Text('Отмена'), // Текст на кнопке
            //               ),
            //               ElevatedButton(
            //                 onPressed: () {
            //                   // Действие при нажатии на кнопку
            //                   // Можно добавить свою логику здесь
            //                 },
            //                 child: const Text('Принять'), // Текст на кнопке
            //               ),
            //             ],
            //           ));
            // }
