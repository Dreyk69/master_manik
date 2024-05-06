import 'package:ananasik_nails/app/blocs/identification_bloc/identification_bloc.dart';
import 'package:ananasik_nails/app/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:ananasik_nails/presentation/mainScreen/screen/clientScreen/profileClientScreen/profile_client_screen.dart';
import 'package:ananasik_nails/presentation/mainScreen/screen/manicuristScreen/profileManicuristScreen/profile_manicurist_screen.dart';
import 'package:ananasik_nails/presentation/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/logic/application_logic.dart';
import '../../../../../infrastructure/navigation_service.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final List<String> element = [
    "Профиль",
    "Выход",
  ];
  final List<IconData> icons = [
    Icons.account_circle,
    Icons.exit_to_app,
  ];

  final navigationService = AppInitializer.getIt<NavigationService>();

  void onTapFunction(int index, BuildContext context, String routeName) {
    switch (index) {
      case 0:
        navigationService.navigateTo(routeName);
      case 1:
        context.read<SignInBloc>().add(const SignOutRequired());
    }
  }

  late final IdentificationBloc _identificationBloc;

  void dispose() {
    _identificationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    String routeName;
    return BlocBuilder<IdentificationBloc, IdentificationState>(
        builder: (context, state) {
      if (state is IdentificationClient) {
        routeName = ProfileClientScreen.routeName;
      } else if (state is IdentificationManicurist) {
        routeName = ProfileManicuristScreen.routeName;
      } else {
        routeName = NotFoundScreen.routeName;
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ananasik Nails'),
          backgroundColor: const Color.fromARGB(255, 254, 199, 236),
        ),
        body: Center(
            child: ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: element.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(element[index], style: const TextStyle(fontSize: 22)),
              leading: Icon(
                icons[index],
                color: const Color.fromARGB(255, 205, 92, 184),
              ),
              onTap: () {
                onTapFunction(index, context, routeName);
              },
            );
          },
        )),
      );
    });
  }
}
