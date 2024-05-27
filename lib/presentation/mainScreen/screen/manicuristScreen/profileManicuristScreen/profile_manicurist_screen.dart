import 'package:ananasik_nails/app/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:ananasik_nails/domain/repository/post_repository/lib/post_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../app/blocs/get_data_bloc/get_data_bloc.dart';
import '../../../../../app/blocs/post_bloc/post_bloc.dart';
import '../../../../../constants/styles/icons.dart';
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
  final ScrollController _scrollController = ScrollController();
  String textField1Value = '';
  String textField2Value = '';

  @override
  Widget build(BuildContext globalContext) {
    return BlocProvider(
      create: (userRepositoryContext) => GetDataBloc(
          myUserRepository:
              userRepositoryContext.read<AuthBloc>().userRepository),
      child: BlocBuilder<GetDataBloc, GetDataState>(
        builder: (getDataContext, state) {
          Image avatarPhoto;
          List<dynamic> spisokfotorabot = [''];
          bool photoRabot;
          bool spisokUslugBool;
          List<dynamic> spisokUslugProverka = [];
          List<Map<String, int>> uslugiList = [];
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

          if (dataUser?['avatar'] != null && dataUser?['avatar'] != '') {
            avatarPhoto = Image.network(
              dataUser?['avatar'],
              fit: BoxFit.cover,
            );
          } else {
            avatarPhoto = Image.asset(
              avaString,
              fit: BoxFit.cover,
            );
          }

          if (dataUser?['photoRabot'] != null) {
            spisokfotorabot = dataUser?['photoRabot'];
            if (spisokfotorabot.isNotEmpty) {
              if (spisokfotorabot[0] != '') {
                photoRabot = false;
              } else {
                photoRabot = true;
              }
            } else {
              photoRabot = true;
            }
          } else {
            photoRabot = true;
          }

          if (dataUser?['uslugi'] != null) {
            spisokUslugProverka = dataUser?['uslugi'];
            if (spisokUslugProverka.isNotEmpty) {
              if (!spisokUslugProverka[0].isEmpty) {
                uslugiList = spisokUslugProverka.map((item) {
                  if (item is Map) {
                    return item.map(
                        (key, value) => MapEntry(key.toString(), value as int));
                  } else {
                    return <String, int>{};
                  }
                }).toList();
                spisokUslugBool = false;
              } else {
                spisokUslugBool = true;
              }
            } else {
              spisokUslugBool = true;
            }
          } else {
            spisokUslugBool = true;
          }
          return BlocProvider(
            create: (userRepositoryContext) => UpdateUserInfoBloc(
                userRepository:
                    userRepositoryContext.read<AuthBloc>().userRepository),
            child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
              builder: (updateUserInfoContext, state) {
                // -----------------------------------------------------------------------------------------------------------
                if (state is UploadPictureSuccess) {
                  avatarPhoto = Image.network(
                    state.userImage,
                    fit: BoxFit.cover,
                  );
                }
                if (state is UploadListPictureSuccess) {
                  spisokfotorabot = state.updateListPhoto;
                  photoRabot = false;
                }
                if (state is UploadListUslugSuccess) {
                  uslugiList = state.updateListUslug;
                  spisokUslugBool = false;
                }
                return Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(255, 254, 199, 236),
                      title: const Text('Ananasik Nails'),
                    ),
                    floatingActionButton: FloatingActionButton.extended(
                      label: const Text('Опубликовать'),
                      onPressed: () {
                        MyPost myPost = MyPost.empty;
                        List<String> spisokfotorabotStr = spisokfotorabot
                            .map((item) => item.toString())
                            .toList(); 
                        Map<DateTime, List<String>> convertMap(
                            Map<String, dynamic>? inputMap) {
                          // Проверка на null
                          if (inputMap == null) {
                            return {};
                          }

                          Map<DateTime, List<String>> dateTimeMap = {};

                          // Проход по каждому элементу исходного Map
                          inputMap.forEach((key, value) {
                            try {
                              // Преобразование ключа в DateTime
                              DateTime date = DateTime.parse(key);

                              // Проверка и преобразование значения в List<String>
                              if (value is List<dynamic>) {
                                List<String> stringList = value
                                    .map((item) => item.toString())
                                    .toList();
                                dateTimeMap[date] = stringList;
                              }
                            } catch (e) {
                              // Обработка ошибок преобразования
                              print(
                                  'Error parsing key $key or value $value: $e');
                            }
                          });

                          return dateTimeMap;
                        }
                        Map<DateTime, List<String>> spisokOkohek = convertMap(dataUser?['okohki']);
                        Map<String, dynamic> okohkiToSave = spisokOkohek.map((key, value) => MapEntry(
          key.toIso8601String(),
          value,
        ));
                        if (dataUser?['avatar'] != '') {
                          myPost = myPost.copyWith(
                            id: dataUser?['id'],
                            email: dataUser?['email'],
                            name: dataUser?['name'],
                            avatar: dataUser?['avatar'],
                            photoRabot: spisokfotorabotStr,
                            uslugi: uslugiList,
                            okohki: okohkiToSave,
                          );
                        } else {
                          myPost = myPost.copyWith(
                            id: dataUser?['id'],
                            email: dataUser?['email'],
                            name: dataUser?['name'],
                            photoRabot: spisokfotorabotStr,
                            uslugi: uslugiList,
                            okohki: okohkiToSave,
                          );
                        }
                        setState(() {
                          globalContext.read<PostBloc>().add(SetPost(myPost));
                        });
                      },
                    ),
                    body: !_signInRequired
                        ? ListView(
                            controller: _scrollController,
                            children: [
                              Column(
                                children: [
                                  DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 254, 199, 236)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 0),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          InkWell(
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
                                                    CropAspectRatioPreset.square
                                                  ],
                                                  uiSettings: [
                                                    AndroidUiSettings(
                                                        toolbarTitle: 'Cropper',
                                                        toolbarColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                254, 199, 236),
                                                        toolbarWidgetColor:
                                                            Colors.white,
                                                        initAspectRatio:
                                                            CropAspectRatioPreset
                                                                .original,
                                                        lockAspectRatio: false),
                                                    IOSUiSettings(
                                                        title: 'Cropper'),
                                                  ],
                                                );
                                                if (croppedFile != null) {
                                                  setState(() {
                                                    // ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    updateUserInfoContext
                                                        .read<
                                                            UpdateUserInfoBloc>()
                                                        .add(UploadPicture(
                                                            croppedFile.path,
                                                            dataUser?['id']));
                                                  });
                                                }
                                              }
                                            },
                                            child: ClipOval(
                                                child: SizedBox.fromSize(
                                                    size: const Size.fromRadius(
                                                        35),
                                                    child: avatarPhoto)),
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
                                        child: !photoRabot
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(14.0),
                                                child: CustomScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  slivers: <Widget>[
                                                    SliverList.builder(
                                                        itemCount:
                                                            spisokfotorabot
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Image.network(
                                                                  spisokfotorabot[
                                                                      index],
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                ))
                                                  ],
                                                ))
                                            : const Center(
                                                child: Text('Фоток нет')))
                                  ]),
                                  const SizedBox(height: 1),
                                  SizedBox(
                                    height: 40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black54),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                  source: ImageSource.gallery,
                                                  maxHeight: 2500,
                                                  maxWidth: 2500,
                                                  imageQuality: 50,
                                                );
                                                if (image != null) {
                                                  CroppedFile? croppedFile =
                                                      await ImageCropper()
                                                          .cropImage(
                                                    sourcePath: image.path,
                                                    aspectRatio:
                                                        const CropAspectRatio(
                                                      ratioX: 1.4,
                                                      ratioY: 1.8,
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
                                                      // --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                      updateUserInfoContext
                                                          .read<
                                                              UpdateUserInfoBloc>()
                                                          .add(
                                                              UploadListPicture(
                                                                  croppedFile
                                                                      .path,
                                                                  dataUser?[
                                                                      'id']));
                                                    });
                                                  }
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  plusikIcon,
                                                  const Text('Загрузить фото')
                                                ],
                                              )),
                                          const VerticalDivider(
                                            indent: 5,
                                            endIndent: 5,
                                            color: Colors.black54,
                                            thickness: 2,
                                          ),
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
                                          Text('${dataUser?['email']}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 35),
                                          const Text('Изменить..',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500)),
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
                                    height: 100,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      child: Row(
                                        children: [
                                          Text('Пароль:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(width: 20),
                                          Text('********',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(width: 35),
                                          Text('Изменить..',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500)),
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
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 50),
                                          child: FilledButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        const Color.fromARGB(
                                                            255,
                                                            254,
                                                            199,
                                                            236))),
                                            onPressed: () async {
                                              showDialog<void>(
                                                context: updateUserInfoContext,
                                                // -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Введите новую услугу и цену'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        TextField(
                                                          onChanged: (value) {
                                                            textField1Value =
                                                                value;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Введите название услуги'),
                                                        ),
                                                        TextField(
                                                          onChanged: (value) {
                                                            textField2Value =
                                                                value;
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Введите цену'),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Отмена'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          updateUserInfoContext
                                                              .read<
                                                                  UpdateUserInfoBloc>()
                                                              .add(UploadListUslug(
                                                                  textField1Value,
                                                                  textField2Value,
                                                                  dataUser?[
                                                                      'id']));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Сохранить'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('Добавить'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  !spisokUslugBool
                                      ? SizedBox(
                                          child: Column(children: [
                                          ListView.builder(
                                              controller: _scrollController,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: uslugiList.length,
                                              itemBuilder: (context, index) {
                                                Map<String, int> uslugaMap =
                                                    uslugiList[index];
                                                String usluga =
                                                    uslugaMap.keys.first;
                                                int cena =
                                                    uslugaMap.values.first;
                                                return SizedBox(
                                                  height: 90,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 20,
                                                        horizontal: 20),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Flexible(
                                                            flex: 2,
                                                            child: Text(
                                                              '$usluga:',
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(
                                                          '$cenaр',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                            width: 35),
                                                        const Text('Изменить..',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                          const SizedBox(height: 50)
                                        ]))
                                      : const SizedBox(height: 50)
                                ],
                              ),
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


// {
//                         DateTime? newData = await showDatePicker(
//                             context: updateUserInfoContext,
//                             // ------------------------------------------------------------------------------------------------------------------------------------------
//                             initialDate: today,
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(2100));
//                         // ignore: curly_braces_in_flow_control_structures
//                         if (newData == null)
//                           return;
//                         else {
//                           // ignore: use_build_context_synchronously
//                           return showDialog(
//                               context: updateUserInfoContext,
//                               // ----------------------------------------------------------------------------------------------------------------------------------------------------
//                               builder: (BuildContext context) => AlertDialog(
//                                     title:
//                                         const Text('Выбырите время и услугу'),
//                                     content: Row(
//                                       children: [
//                                         const SizedBox(
//                                           width: 20,
//                                         ),
//                                         DropdownButton<String>(
//                                           hint: const Center(
//                                               child: Text(
//                                             '',
//                                             style:
//                                                 TextStyle(color: Colors.white),
//                                           )),
//                                           value: _dropdownvalue1,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               _dropdownvalue1 = value;
//                                             });
//                                           },
//                                           items: items1.map((e) {
//                                             return DropdownMenuItem(
//                                               value: e,
//                                               child: Text(
//                                                 e,
//                                                 style: const TextStyle(
//                                                     color: Colors.black),
//                                               ),
//                                             );
//                                           }).toList(),
//                                         ),
//                                         const SizedBox(
//                                           width: 20,
//                                         ),
//                                         SizedBox(
//                                           child: DropdownButton<String>(
//                                             hint: const Center(
//                                                 child: Text(
//                                               '',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             )),
//                                             value: _dropdownvalue2,
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 _dropdownvalue2 = value;
//                                               });
//                                             },
//                                             items: items2.map((e) {
//                                               return DropdownMenuItem(
//                                                 value: e,
//                                                 child: SizedBox(
//                                                   width: 150,
//                                                   child: Flexible(
//                                                     flex: 1,
//                                                     child: Text(
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       maxLines: 1,
//                                                       e,
//                                                       style: const TextStyle(
//                                                           color: Colors.black),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             }).toList(),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () {
//                                           // Действие при нажатии на кнопку
//                                           Navigator.of(context)
//                                               .pop(); // Закрываем AlertDialog
//                                         },
//                                         child:
//                                             Text('Отмена'), // Текст на кнопке
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           // Действие при нажатии на кнопку
//                                           // Можно добавить свою логику здесь
//                                         },
//                                         child:
//                                             Text('Принять'), // Текст на кнопке
//                                       ),
//                                     ],
//                                   ));
//                         }
//                       },
