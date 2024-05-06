import 'package:ananasik_nails/constants/styles/icons.dart';
import 'package:ananasik_nails/constants/styles/images.dart';
import 'package:ananasik_nails/constants/styles/styles_text_field.dart';
import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../app/blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../../domain/logic/auth_and_registration_logic.dart';
import 'widgets/my_text_verefication_widget.dart';

class RegistrationWidget extends StatefulWidget {
  static const routeName = '/auth/registration_widget';
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}
enum Options{
  user,
  master
}
List<String> options = ['Пользователь', 'Мастер маникюра'];

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var currentOption = Options.user;
  final nameController = TextEditingController();
  bool _signInRequired = false;
  String? _errorMsgForEmail;
  String? _errorMsgForPassword;
  String? _errorMsgForName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) =>
          SignUpBloc(myUserRepository: context.read<AuthBloc>().userRepository),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Center(child:
            BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
          if (state is SignUpInitial ||
              state is SignUpSuccess ||
              state is SignUpProcess ||
              state is SignUpFailure) {
            if (state is SignUpInitial) {
              _signInRequired = false;
            } else if (state is SignUpSuccess) {
              _signInRequired = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationBack();
                navigationToMainScreen();
              });
            } else if (state is SignUpProcess) {
              _signInRequired = true;
            } else if (state is SignUpFailure) {
              _signInRequired = false;
              _errorMsgForPassword = 'Ошибка регистрации';
            }
          }
          return Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 80, horizontal: 50),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // проверить
                      children: [
                        Center(child: logotip),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            return validatorForEmail(val);
                          },
                          decoration: StylesTextField(
                            hintText: 'Введите Email',
                            prefixIcon: emailIcon,
                            errorText: _errorMsgForEmail,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (val) {
                            return validatorForPassword(val);
                          },
                          onChanged: (val) {
                            setState(() {
                              passwordVerification(val);
                            });
                            // return null;
                          },
                          decoration: StylesTextField(
                            hintText: 'Введите пароль',
                            prefixIcon: passwordIcon,
                            errorText: _errorMsgForPassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordDisplay();
                                });
                              },
                              icon: Icon(iconPassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextVerefication(
                                  text: '• 1 Заглавная',
                                  verefication: containsUpperCase,
                                ),
                                MyTextVerefication(
                                  text: '• 1 Строчная',
                                  verefication: containsLowerCase,
                                ),
                                MyTextVerefication(
                                  text: '• 1 Цифра',
                                  verefication: containsNumber,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // проверить
                              children: [
                                MyTextVerefication(
                                  text: '• 1 Специальный символ',
                                  verefication: containsSpecialChar,
                                ),
                                MyTextVerefication(
                                  text: '• Миниум 8 символов',
                                  verefication: contains8Length,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: nameController,
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            return validatorForName(val,
                                nameController: nameController);
                          },
                          decoration: StylesTextField(
                            hintText: 'Введите Email',
                            prefixIcon: nameIcon,
                            errorText: _errorMsgForName,
                          ),
                        ),
                        const SizedBox(height: 10), // исправить
                        SizedBox(
                          height: 40,
                          child: ListTile(
                            title: const Text('Пользователь',
                                style: TextStyle(fontSize: 14)),
                            leading: Radio(
                                value: Options.user,
                                groupValue: currentOption,
                                onChanged: (value) {
                                  setState(() {
                                    currentOption = Options.user;
                                  });
                                }),
                          ),
                        ),
                        const SizedBox(width: 30), // исправить
                        SizedBox(
                          height: 40,
                          child: ListTile(
                            title: const Text('Мастер маникюра',
                                style: TextStyle(fontSize: 14)),
                            leading: Radio(
                                value: Options.master,
                                groupValue: currentOption,
                                onChanged: (value) {
                                  setState(() {
                                    currentOption = Options.master;
                                  });
                                }),
                          ),
                        ),
                        const SizedBox(height: 20),
                        !_signInRequired
                            ? SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (currentOption == Options.user) {
                                        MyClient myClient = MyClient.empty;
                                        myClient = myClient.copyWith(
                                            email: emailController.text,
                                            name: nameController.text);
                                        setState(() {
                                          context.read<SignUpBloc>().add(
                                              SignUpRequired(
                                                  client: myClient,
                                                  password:
                                                      passwordController.text));
                                        });
                                      } else if (currentOption == Options.master) {
                                        MyManicurist myManicurist =
                                            MyManicurist.empty;
                                        myManicurist = myManicurist.copyWith(
                                            email: emailController.text,
                                            name: nameController.text);
                                        setState(() {
                                          context.read<SignUpBloc>().add(
                                              SignUpRequired(
                                                  manicurist: myManicurist,
                                                  password:
                                                      passwordController.text));
                                        });
                                      }
                                    }
                                  },
                                  child: const Text('Зарегистрироваться'),
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ]),
                ),
              ));
        })),
      ),
    );
  }
}
