import 'package:ananasik_nails/constants/styles/images.dart';
import 'package:flutter/material.dart';

class RibbonScreen extends StatelessWidget {
  const RibbonScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          SliverList.builder(
              itemBuilder: (context, index) => const CardMaster())
        ],
      ),
    );
  }
}

class CardMaster extends StatelessWidget {
  const CardMaster({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      elevation: 0,
      color: Color.fromARGB(255, 252, 227, 248),
      child: Column(
        children: [
          PersonalInf(),
          PricesSchedule(),
          PhotosWork(),
        ],
      ),
    );
  }
}

class PhotosWork extends StatelessWidget {
  const PhotosWork({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 500,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
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
            Image.asset(
              'assets/image/1569313078_nezhno-sirenevyj-manikjur-pinterest-37.jpg',
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class PricesSchedule extends StatelessWidget {
  const PricesSchedule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'Аппаратный маникюр',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '2000р',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      'Ручная роспись(ноготь)',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Text(
                    '150р',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      'Коррекция нарощенных ногтей',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Text(
                    '2000р',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 199, 236),
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: const Column(
              children: [
                Text(
                  '14 апр.',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '12:00',
                  style: TextStyle(fontSize: 12),
                )
              ],
            )),
        Container(
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 199, 236),
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: const Column(
              children: [
                Text(
                  '14 апр.',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '14:00',
                  style: TextStyle(fontSize: 12),
                )
              ],
            )),
        Container(
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 254, 199, 236),
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: const Column(
              children: [
                Text(
                  '14 апр.',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  '16:00',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ))
      ],
    );
  }
}

class PersonalInf extends StatelessWidget {
  const PersonalInf({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipOval(
            child: SizedBox.fromSize(
          size: const Size.fromRadius(35),
          child: ava
        )),
        const Column(
          children: [
            Text('Петрова Алина Андреевна'),
            Text('13 отзывов'),
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
