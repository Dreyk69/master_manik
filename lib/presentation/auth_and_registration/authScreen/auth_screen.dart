import 'package:ananasik_nails/constants/styles/icons.dart';
import 'package:ananasik_nails/constants/styles/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../app/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../../constants/styles/styles_text_field.dart';
import '../../../domain/logic/auth_and_registration_logic.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsgForEmail;
  String? _errorMsgForPassword;
  bool _signInRequired = false;
  late final SignInBloc _signInBloc;

  @override
  void initState() {
    super.initState();
    _signInBloc =
        SignInBloc(myUserRepository: context.read<AuthBloc>().userRepository);
  }

  @override
  void dispose() {
    _signInBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => _signInBloc,
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          if (state is SignInInitial ||
              state is SignInSuccess ||
              state is SignInProcess ||
              state is SignInFailure) {
            if (state is SignInInitial) {
              _signInRequired = false;
            } else if (state is SignInSuccess) {
              _signInRequired = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigationToMainScreen();
              });
            } else if (state is SignInProcess) {
              _signInRequired = true;
            } else if (state is SignInFailure) {
              _signInRequired = false;
              _errorMsgForPassword =
                  'Неправильный адрес электронной почты или пароль';
            }
          }
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 150, horizontal: 90),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: logotip),
                          const SizedBox(height: 20),
                          TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                return validatorForEmail(val);
                              },
                              decoration: StylesTextField(
                                hintText: 'Введите Email',
                                prefixIcon: emailIcon,
                                errorText: _errorMsgForEmail,
                              )),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (val) {
                              return validatorForPassword(val);
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
                                )),
                          ),
                          const SizedBox(height: 5),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Забыли пароль?'),
                          ),
                          const SizedBox(height: 5),
                          !_signInRequired
                              ? Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        onPressed: () {
                                          if (_formKey.currentState != null &&
                                              _formKey.currentState!
                                                  .validate()) {
                                            context
                                                .read<SignInBloc>()
                                                .add(SignInRequired(
                                                  emailController.text,
                                                  passwordController.text,
                                                ));
                                          }
                                        },
                                        child: const Text('Войти'),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        onPressed: () {
                                          navigationToRegistrationScreen();
                                        },
                                        child: const Text('Регистрация'),
                                      ),
                                    ),
                                  ],
                                )
                              : const CircularProgressIndicator()
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
