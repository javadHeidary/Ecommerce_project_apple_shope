import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/bloc/basket/basket_bloc.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/res/app_svg.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/categoray_screen.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int iconSelected = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategorayScreen(),
    BlocProvider<BasketBloc>.value(
      value: locator.get<BasketBloc>(),
      child: const CartScreen(),
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: iconSelected,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: AppColor.blue,
          unselectedItemColor: AppColor.gray,
          selectedLabelStyle: const TextStyle(fontFamily: 'SB'),
          unselectedLabelStyle: const TextStyle(fontFamily: 'SB'),
          currentIndex: iconSelected,
          onTap: (int index) {
            setState(() {
              iconSelected = index;
            });
          },
          items: _navItems
              .map((item) => _buildBottomNavigationBarItem(item))
              .toList(),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(_NavItemData item) {
    return BottomNavigationBarItem(
      label: item.label,
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset(
          item.outlineIcon,
          width: 20,
          height: 20,
        ),
      ),
      activeIcon: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              spreadRadius: -7,
              offset: Offset(0.0, 10),
              color: AppColor.blue,
            ),
          ],
        ),
        child: SvgPicture.asset(
          item.boldIcon,
          width: 20,
          height: 20,
          color: AppColor.blue,
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final String outlineIcon;
  final String boldIcon;

  _NavItemData({
    required this.label,
    required this.outlineIcon,
    required this.boldIcon,
  });
}

final List<_NavItemData> _navItems = [
  _NavItemData(
    label: 'خانه',
    outlineIcon: AppSvg.homeOutline,
    boldIcon: AppSvg.homeBold,
  ),
  _NavItemData(
    label: 'دسته بندی',
    outlineIcon: AppSvg.categorayOutline,
    boldIcon: AppSvg.categorayBold,
  ),
  _NavItemData(
    label: 'سبد خرید',
    outlineIcon: AppSvg.shoppingOutline,
    boldIcon: AppSvg.shoppingBold,
  ),
  _NavItemData(
    label: 'حساب کاربری',
    outlineIcon: 'assets/images/user_outline.svg',
    boldIcon: AppSvg.userBold,
  ),
];
