import 'package:ananasik_nails/presentation/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/blocs/auth_bloc/auth_bloc.dart';
import '../../app/blocs/identification_bloc/identification_bloc.dart';
import 'screen/clientScreen/recordingClientScreen/recording_client_screen.dart';
import 'screen/generalScreen/favoritesScreen/favorites_screen.dart';
import 'screen/generalScreen/menuScreen/menu_screen.dart';
import 'screen/manicuristScreen/recordingManicuristScreen/recording_manicurist_screen.dart';
import 'screen/generalScreen/ribbonScreen/ribbon_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/main_screen';
  static final List<Widget> _widgetOptionManicurist = <Widget>[
    const RibbonScreen(),
    const FavoritesScreen(),
    const RecordingManicuristScreen(),
    MenuScreen(),
  ];

  static final List<Widget> _widgetOptionClient = <Widget>[
    const RibbonScreen(),
    const FavoritesScreen(),
    const RecordingClientScreen(),
    MenuScreen(),
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTab = 0;
  List<Widget> _widgetOption = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdentificationBloc, IdentificationState>(
        builder: (context, state) {
      if (state is IdentificationClient) {
        _widgetOption = MainScreen._widgetOptionClient;
      } else if (state is IdentificationManicurist) {
        _widgetOption = MainScreen._widgetOptionManicurist;
      } else {
        _widgetOption = <Widget>[const NotFoundScreen()];
      }
      return Scaffold(
        body: Center(
            child: BlocProvider<IdentificationBloc>(
          create: (context) => IdentificationBloc(
              myUserRepository: context.read<AuthBloc>().userRepository),
          child: _widgetOption[_selectedTab],
        )),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedTab,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Записи',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dehaze),
              label: 'Меню',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 254, 199, 236),
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
        ),
      );
    });
  }
}


// Colors.red