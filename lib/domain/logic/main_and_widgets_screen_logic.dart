import 'package:ananasik_nails/app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// menu_logic:

void onTapFunction() {}

void fun1() {}

void fun2(BuildContext context) {
  context.read<SignInBloc>().add(const SignOutRequired());
}
