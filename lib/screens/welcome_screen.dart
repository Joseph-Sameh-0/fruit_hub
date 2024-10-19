import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String?> getNameFromPreferences() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_name');
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFFFF9833),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Image.asset('assets/images/fruit_basket.png'),
                const SizedBox(height: 20),
              ]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    textAlign: TextAlign.start,
                    'Get The Freshest Fruit Salad Combo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 50),
                  child: Text(
                    'We deliver the best and freshest fruit salad in town. Order for a combo today!!!',
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await getNameFromPreferences() == null) {
                        Navigator.pushNamed(context, '/auth');
                      } else {
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9833),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 20)),
                    child: const Text(
                      "Let's Continue",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
