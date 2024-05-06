import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../app/blocs/get_data_bloc/get_data_bloc.dart';

// ignore: must_be_immutable
class ProfileClientScreen extends StatelessWidget {
  ProfileClientScreen({super.key});
  static const routeName = '/main/profile_client_screen';
  late final GetDataBloc _getDataBloc;
  bool _signInRequired = false;
  Map<String, dynamic>? dataUser;

  void dispose() {
    _getDataBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetDataBloc>(
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
                                ClipOval(
                                    child: SizedBox.fromSize(
                                  size: const Size.fromRadius(35),
                                  child: Image.asset(
                                    'assets/image/avatar.png',
                                    fit: BoxFit.cover,
                                  ),
                                )),
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
                        SizedBox(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
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
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
