import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../../../../app/blocs/get_data_bloc/get_data_bloc.dart';
import 'package:intl/intl.dart';

class RecordingClientScreen extends StatelessWidget {
  const RecordingClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? dateZapis;
    String timeZapis = '';
    String usluga = '';
    int? price;
    String name = '';
    String email = '';
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
          return !_signInRequired ? Scaffold(
                      appBar: AppBar(
                        title: const Text('Ananasik Nails'),
                        backgroundColor:
                            const Color.fromARGB(255, 254, 199, 236),
                      ),
                      body: 
                        ListView.builder(
                          itemBuilder:
                            (context, index) {
                              Map<String, dynamic> postMap =
                                  dataUserZapis![index];
                              dateZapis = postMap['dateZapis'].toDate();
                              String date = DateFormat('dd-MM').format(dateZapis!);
                              timeZapis = postMap['timeZapis'];
                              usluga = postMap['usluga'];
                              price = postMap['price'];
                              name = postMap['nameMaster'];
                              email = postMap['emailMaster'];
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
                                          Text('Ваш мастер: $name'),
                                          Text('Почта мастера: $email'),
                                          Text(
                                              'Услуга: $usluga. Цена: $priceр'),
                                        ]),
                                  ));
                            },
                            itemCount: dataUserZapis?.length ?? 0,
                        ),
                      ) : const Center(child: CircularProgressIndicator());
        }));
  }
}
