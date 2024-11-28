import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop/bloc/basket/basket_bloc.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';
import 'package:shop/di/di.dart';
import 'package:shop/screens/dashboard_screen.dart';
import 'package:shop/screens/login_screen.dart';
import 'package:shop/util/auth_managment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BasketItemModelAdapter());
  await Hive.openBox<BasketItemModel>('BasketBox');
  await serviceLocator();
  runApp(
    const ShopeApp(),
  );
}

class ShopeApp extends StatelessWidget {
  const ShopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => locator.get<BasketBloc>(),
        child: AuthManagment.isLogin()
            ? const DashboardScreen()
            : const LoginScreen(),
      ),
    );
  }
}
