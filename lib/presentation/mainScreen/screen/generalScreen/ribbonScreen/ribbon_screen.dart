import 'package:ananasik_nails/app/blocs/auth_bloc/auth_bloc.dart';
import 'package:ananasik_nails/app/blocs/post_bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/logic/application_logic.dart';
import '../../../../../infrastructure/navigation_service.dart';
import 'screen/zapisScreen/zapis_screen.dart';

class RibbonScreen extends StatefulWidget {
  const RibbonScreen({super.key});

  @override
  State<RibbonScreen> createState() => _RibbonScreenState();
}

class _RibbonScreenState extends State<RibbonScreen> {
  bool _signInRequired = false;
  List<Map<String, dynamic>> post = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (userRepositoryContext) => PostBloc(
            myPostRepository:
                userRepositoryContext.read<AuthBloc>().postRepository),
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state is PostInitial) {
            _signInRequired = true;
          } else if (state is PostProcess) {
            _signInRequired = true;
          } else if (state is PostGetSuccess) {
            _signInRequired = false;
            post = state.post;
          }
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                const SliverAppBar(
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: Text('Ananasik Nails'),
                  backgroundColor: Color.fromARGB(255, 254, 199, 236),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: SearchButton(),
                  ),
                ),
                !_signInRequired
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            Map<String, dynamic> postMap = post[index];
                            return CardMaster(postMap);
                          },
                          childCount: post.length,
                        ),
                      )
                    : const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      )
              ],
            ),
          );
        }));
  }
}

class CardMaster extends StatelessWidget {
  const CardMaster(
    this.post, {
    super.key,
  });
  final Map<String, dynamic> post;

  @override
  Widget build(BuildContext context) {
    final navigationService = AppInitializer.getIt<NavigationService>();
    List<dynamic> spisokUslugProverka = [];
    final List<Map<String, int>> uslugi;
    final String name = post['name'];
    final List<dynamic> photoRabot = post['photoRabot'];
    spisokUslugProverka = post['uslugi'];
    uslugi = spisokUslugProverka.map((item) {
      if (item is Map) {
        return item.map((key, value) => MapEntry(key.toString(), value as int));
      } else {
        return <String, int>{};
      }
    }).toList();
    Map<DateTime, List<String>> events = {};
    dynamic prohodnoyEvent = post['okohki'];
    prohodnoyEvent.forEach((key, value) {
      DateTime date = DateTime.parse(key);
      List<String> eventList = List<String>.from(value);
      events[date] = eventList;
    });

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
    return GestureDetector(
      onTap: () {
        navigationService.navigateTo(ZapisScreen.routeName, arguments: post);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        elevation: 0,
        color: const Color.fromARGB(255, 252, 227, 248),
        child: Column(
          children: [
            PersonalInf(
              name: name,
              ava: ava,
            ),
            PricesSchedule(
              uslugi: uslugi,
              events: events,
            ),
            PhotosWork(
              photoRabot: photoRabot,
            ),
          ],
        ),
      ),
    );
  }
}

class PhotosWork extends StatelessWidget {
  const PhotosWork({
    super.key,
    required this.photoRabot,
  });
  final List<dynamic> photoRabot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 500,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: <Widget>[
          SliverList.builder(
              itemCount: photoRabot.length,
              itemBuilder: (context, index) => Image.network(
                    photoRabot[index],
                    fit: BoxFit.fitHeight,
                  ))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PricesSchedule extends StatefulWidget {
  PricesSchedule({
    super.key,
    required this.uslugi,
    required this.events,
  });
  List<Map<String, int>> uslugi;
  Map<DateTime, List<String>> events;
  DateTime now = DateTime.now();

  @override
  State<PricesSchedule> createState() => _PricesScheduleState();
}

class _PricesScheduleState extends State<PricesSchedule> {
  // SizedBox(
  @override
  Widget build(BuildContext context) {
    List<DateTime> upcomingEvents =
        getUpcomingEvents(widget.events, widget.now, 3);
    return Row(
      children: <Widget>[
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      widget.uslugi.length < 4 ? widget.uslugi.length : 3,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, int> uslugaMap = widget.uslugi[index];
                    String usluga = uslugaMap.keys.first;
                    int cena = uslugaMap.values.first;
                    return Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            '$usluga: ',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        Text(
                          '$cenaр',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            const Text('Ближайшее время для записи:', style: const TextStyle(fontSize: 12),),
            SizedBox(
              height: 60,
              width: 240,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  DateTime eventDateTime = upcomingEvents[index];
                  String date = DateFormat('dd-MM').format(eventDateTime);
                  String time = DateFormat('HH:mm').format(eventDateTime);
                  return Container(
                    width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 254, 199, 236),
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$date',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            '$time',
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

List<DateTime> getUpcomingEvents(
    Map<DateTime, List<String>> events, DateTime currentTime, int count) {
  List<DateTime> allEventTimes = [];

  events.forEach((date, times) {
    for (String time in times) {
      DateTime eventTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(time.split(':')[0]),
        int.parse(time.split(':')[1]),
      );
      allEventTimes.add(eventTime);
    }
  });

  allEventTimes = allEventTimes
      .where((eventTime) => eventTime.isAfter(currentTime))
      .toList();
  allEventTimes.sort();

  return allEventTimes.take(count).toList();
}

class PersonalInf extends StatelessWidget {
  const PersonalInf({
    super.key,
    required this.name,
    required this.ava,
  });
  final String name;
  final Image ava;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipOval(
            child:
                SizedBox.fromSize(size: const Size.fromRadius(35), child: ava)),
        Column(
          children: [
            Text(name),
            const Text('13 отзывов'),
          ],
        ),
        const Icon(Icons.favorite_border)
      ],
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded),
          const SizedBox(width: 12),
          Text(
            'Поиск мастера',
            style: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
