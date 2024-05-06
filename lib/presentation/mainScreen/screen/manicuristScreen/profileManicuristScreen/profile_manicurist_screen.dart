import 'package:ananasik_nails/app/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../app/blocs/get_data_bloc/get_data_bloc.dart';
import '../../../../../constants/styles/images.dart';

// ignore: must_be_immutable
class ProfileManicuristScreen extends StatefulWidget {
  const ProfileManicuristScreen({super.key});
  static const routeName = '/main/profile_manicurist_screen';

  @override
  State<ProfileManicuristScreen> createState() =>
      _ProfileManicuristScreenState();
}

class _ProfileManicuristScreenState extends State<ProfileManicuristScreen> {
  bool _signInRequired = false;
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // the selected value
  String? _dropdownvalue1;
  // the selected value
  String? _dropdownvalue2;

  var items1 = [
    '12:00',
    '14:00',
    '16:00',
  ];
  var items2 = [
    'Аппаратный маникюр: 2000р',
    'Ручная роспись (ноготь): 150р',
    'Коррекция нарощенных ногтей: 2000р',
  ];

  Map<String, dynamic>? dataUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateUserInfoBloc(
          userRepository: context.read<AuthBloc>().userRepository),
      child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
        builder: (context, state) {
          return BlocProvider(
            create: (context) => GetDataBloc(
                myUserRepository: context.read<AuthBloc>().userRepository),
            child: BlocBuilder<GetDataBloc, GetDataState>(
              builder: (context, state) {
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

                return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(255, 254, 199, 236),
                      title: const Text('Ananasik Nails'),
                    ),
                    floatingActionButton: FloatingActionButton.extended(
                      label: const Text('Записаться'),
                      onPressed: () async {
                        DateTime? newData = await showDatePicker(
                            context: context,
                            initialDate: today,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        // ignore: curly_braces_in_flow_control_structures
                        if (newData == null)
                          return;
                        else {
                          // ignore: use_build_context_synchronously
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title:
                                        const Text('Выбырите время и услугу'),
                                    content: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        DropdownButton<String>(
                                          hint: const Center(
                                              child: Text(
                                            '',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                          value: _dropdownvalue1,
                                          onChanged: (value) {
                                            setState(() {
                                              _dropdownvalue1 = value;
                                            });
                                          },
                                          items: items1.map((e) {
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        SizedBox(
                                          child: DropdownButton<String>(
                                            hint: const Center(
                                                child: Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                            value: _dropdownvalue2,
                                            onChanged: (value) {
                                              setState(() {
                                                _dropdownvalue2 = value;
                                              });
                                            },
                                            items: items2.map((e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Flexible(
                                                    flex: 1,
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      e,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Действие при нажатии на кнопку
                                          Navigator.of(context)
                                              .pop(); // Закрываем AlertDialog
                                        },
                                        child:
                                            Text('Отмена'), // Текст на кнопке
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Действие при нажатии на кнопку
                                          // Можно добавить свою логику здесь
                                        },
                                        child:
                                            Text('Принять'), // Текст на кнопке
                                      ),
                                    ],
                                  ));
                        }
                      },
                    ),
                    body: !_signInRequired
                        ? Column(
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
                                      dataUser?['avatar'] == ''
                                          ? InkWell(
                                              onTap: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                  maxHeight: 500,
                                                  maxWidth: 500,
                                                  imageQuality: 40,
                                                );
                                                if (image != null) {
                                                  CroppedFile? croppedFile =
                                                      await ImageCropper()
                                                          .cropImage(
                                                    sourcePath: image.path,
                                                    aspectRatio:
                                                        const CropAspectRatio(
                                                      ratioX: 1,
                                                      ratioY: 1,
                                                    ),
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .square
                                                    ],
                                                    uiSettings: [
                                                      AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Cropper',
                                                          toolbarColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  254, 199, 236),
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                      IOSUiSettings(
                                                          title: 'Cropper'),
                                                    ],
                                                  );
                                                  if (croppedFile != null) {
                                                    setState(() {
                                                      context.read<UpdateUserInfoBloc>().add(UploadPicture(croppedFile.path, dataUser?['id']));
                                                    });
                                                  }
                                                }
                                              },
                                              child: ClipOval(
                                                  child: SizedBox.fromSize(
                                                size: const Size.fromRadius(35),
                                                child: ava,
                                              )),
                                            )
                                          : InkWell(
                                              onTap: () {},
                                              child: ClipOval(
                                                  child: SizedBox.fromSize(
                                                      size:
                                                          const Size.fromRadius(
                                                              35),
                                                      child: Image.network(
                                                        '${dataUser?['avatar']}',
                                                        fit: BoxFit.cover,
                                                      ))),
                                            ),
                                      const SizedBox(width: 15),
                                      Text('${dataUser?['name']}',
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
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/image/1569313078_nezhno-sirenevyj-manikjur-pinterest-37.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                          Image.asset(
                                            'assets/image/manik1.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                          Image.asset(
                                            'assets/image/manik2.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                          Image.asset(
                                            'assets/image/manik3.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                          Image.asset(
                                            'assets/image/1569313078_nezhno-sirenevyj-manikjur-pinterest-37.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                          Image.asset(
                                            'assets/image/1569313078_nezhno-sirenevyj-manikjur-pinterest-37.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                          Image.asset(
                                            'assets/image/1569313078_nezhno-sirenevyj-manikjur-pinterest-37.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                              const SizedBox(height: 1),
                              SizedBox(
                                height: 40,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black54),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Center(
                                      child: Text(
                                    'Все работы...',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
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
                                      Text('${dataUser?['email']}',
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      // const SizedBox(width: 35),
                                      // const Text('Изменить..',
                                      //     style: TextStyle(
                                      //         color: Colors.blue,
                                      //         fontSize: 10,
                                      //         fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Colors.black45,
                              ),
                              const SizedBox(
                                height: 250,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Column(children: [
                                          Flexible(
                                            child: Text(
                                              'Аппаратный маникюр:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Flexible(
                                            child: Text(
                                              'Ручная роспись (ноготь):',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Flexible(
                                            child: Text(
                                              'Коррекция нарощенных ногтей:',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          // const SizedBox(height: 20),
                                          // FilledButton(
                                          //   style: ButtonStyle(
                                          //       backgroundColor:
                                          //           MaterialStateProperty.all<
                                          //                   Color>(
                                          //               const Color.fromARGB(
                                          //                   255,
                                          //                   254,
                                          //                   199,
                                          //                   236))),
                                          //   onPressed: () {},
                                          //   child: const Text('Добавить'),
                                          // ),
                                        ]),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Text(
                                            '2000р',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            '150р',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 25),
                                          Text(
                                            '2000р',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(width: 35),
                                      // const Column(
                                      //   children: [
                                      //     Text('Изменить..',
                                      //         style: TextStyle(
                                      //             color: Colors.blue,
                                      //             fontSize: 10,
                                      //             fontWeight: FontWeight.w500)),
                                      //     SizedBox(height: 35),
                                      //     Text('Изменить..',
                                      //         style: TextStyle(
                                      //             color: Colors.blue,
                                      //             fontSize: 10,
                                      //             fontWeight: FontWeight.w500)),
                                      //     SizedBox(height: 35),
                                      //     Text('Изменить..',
                                      //         style: TextStyle(
                                      //             color: Colors.blue,
                                      //             fontSize: 10,
                                      //             fontWeight: FontWeight.w500)),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              // const Divider(
                              //   indent: 20,
                              //   endIndent: 20,
                              //   color: Colors.black45,
                              // ),
                              // const SizedBox(
                              //   height: 100,
                              //   child: Padding(
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 20, horizontal: 20),
                              //     child: Row(
                              //       children: [
                              //         Text('Пароль:',
                              //             style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.w600)),
                              //         SizedBox(width: 20),
                              //         Text('********',
                              //             style: TextStyle(
                              //                 color: Colors.grey,
                              //                 fontSize: 14,
                              //                 fontWeight: FontWeight.w600)),
                              //         SizedBox(width: 35),
                              //         Text('Изменить..',
                              //             style: TextStyle(
                              //                 color: Colors.blue,
                              //                 fontSize: 10,
                              //                 fontWeight: FontWeight.w500)),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        : const Center(child: CircularProgressIndicator()));
              },
            ),
          );
        },
      ),
    );
  }
}


// showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) => AlertDialog(
                        //         title: const Text('Выберите дату и время'),
                        //         content: SizedBox(
                        //           width: 100,
                        //           height: 100,
                        //           child: TableCalendar(
                        //             rowHeight: 43,
                        //             headerStyle: const HeaderStyle(
                        //                 formatButtonVisible: false,
                        //                 titleCentered: true),
                        //             availableGestures: AvailableGestures.all,
                        //             selectedDayPredicate: (day) => isSameDay(day, today),
                        //             focusedDay: today,
                        //             firstDay: DateTime.utc(2010, 10, 16),
                        //             lastDay: DateTime.utc(2030, 3, 14),
                        //             onDaySelected: _onDaySelected,
                        //           ),
                        //         )));
