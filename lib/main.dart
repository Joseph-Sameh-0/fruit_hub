import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p6/screens/authentication_screen.dart';
import 'package:p6/screens/home_screen.dart';
import 'package:p6/screens/order_complete_screen.dart';
import 'package:p6/screens/order_list_screen.dart';
import 'package:p6/screens/splash_screen.dart';
import 'package:p6/screens/track_order.dart';
import 'package:p6/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'cubits/basket_cubit.dart';
import 'cubits/combo_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      BlocProvider<ComboCubit>(
        create: (context) => ComboCubit()..loadCombos(),
      ),
      BlocProvider<BasketCubit>(
        create: (context) => BasketCubit()..loadBasket(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Hub',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/auth': (context) => AuthenticationScreen(),
        '/home': (context) => const HomeScreen(),
        '/basket': (context) => const OrderListScreen(),
        '/orderComplete': (context) => const OrderCompleteScreen(),
        '/trackOrder': (context) => const TrackOrder(),
      },
    );
  }
}
