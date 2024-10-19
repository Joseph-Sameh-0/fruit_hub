import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p6/cubits/combo_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubits/basket_cubit.dart';
import '../models/combo.dart';
import 'add_to_basket_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComboCubit, List<Combo>>(
      builder: (context, combos) {
        return Scaffold(
          body: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topBar(context),
                searchBarWithFilter(),
                const Text(
                  'Recommended Combo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                recommendedCompo(combos),
                const SizedBox(height: 10),
                comboSection(combos),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<String?> getNameFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name');
}

Widget topBar(BuildContext context) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/icons/menu.svg',
              width: 24,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/basket');
            },
            icon: SvgPicture.asset(
              'assets/icons/my_basket.svg',
              width: 24,
            ),
          ),
        ],
      ),
      FutureBuilder<String?>(
        future: getNameFromPreferences(),
        builder: (context, snapshot) {
          String name = "Hello Tony, "; // Default

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.data != null) {
            name = "Hello, ${snapshot.data}! ";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Text(
                    "What fruit salad",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Text("combo do you want today?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
            ],
          );
        },
      ),
    ],
  );
}

Widget searchBarWithFilter() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for fruit salad combos',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.grey),
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget recommendedCompo(List<Combo> recommendedCombos) {
  return Expanded(
    child: ListView.builder(
      itemCount: recommendedCombos.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final combo = recommendedCombos[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddToBasketScreen(combo)),
            );
          },
          child: Card(
            child: SizedBox(
              width: 180,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/icons/heart.svg',
                        width: 24,
                      ),
                    ),
                  ),
                  Image.asset(combo.image, height: 100),
                  const Spacer(),
                  Text(combo.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('ℕ ${combo.price}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.deepOrangeAccent)),
                      IconButton(
                        onPressed: () {
                          context.read<BasketCubit>().addToBasket(combo);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${combo.name} added to basket!')),
                          );
                        },
                        icon: const Icon(Icons.add_circle,
                            color: Colors.deepOrangeAccent),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget comboSection(List<Combo> combos) {
  return DefaultTabController(
    length: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabBar(
          labelColor: Colors.deepOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepOrange,
          tabs: [
            Tab(text: 'Hottest'),
            Tab(text: 'Popular'),
            Tab(text: 'New combo'),
            Tab(text: 'Top'),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 240,
          child: TabBarView(
            children: [
              buildListViewOf(combos),
              buildListViewOf(combos),
              buildListViewOf(combos),
              buildListViewOf(combos),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildListViewOf(List<Combo> combos) {
  List<Combo> shuffledCombos = combos.toList();
  shuffledCombos.shuffle();
  return ListView.builder(
    itemCount: shuffledCombos.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) {
      final combo = shuffledCombos[index];
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddToBasketScreen(combo)),
            );
          },
          child: Container(
            width: 160,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.asset(combo.image, height: 80),
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.favorite_border,
                            color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  combo.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₦ ${combo.price}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.deepOrange)),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepOrange,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          context.read<BasketCubit>().addToBasket(combo);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${combo.name} added to basket!')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    },
  );
}
