import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pelaicons/pelaicons.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/screens/login_screen.dart';
import 'package:shop/util/auth_managment.dart';
import 'package:shop/widgets/appbar__widget.dart';
import 'package:shop/widgets/authentication_bottom_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final List<_ProfileItemData> list = [
    _ProfileItemData(
      title: 'تنطیمات',
      icon: Pelaicons.settings_light_outline,
    ),
    _ProfileItemData(
      title: ' نظرات',
      icon: Pelaicons.personal_card_1_light_outline,
    ),
    _ProfileItemData(
      title: 'سفارش ها',
      icon: Pelaicons.cart_1_svg_bold,
    ),
    _ProfileItemData(
      title: 'بلاگ',
      icon: Pelaicons.text_light_outline,
    ),
    _ProfileItemData(
      title: 'تخفیف ها',
      icon: Pelaicons.ticket_light_outline,
    ),
    _ProfileItemData(
      title: 'اطلاعیه',
      icon: Pelaicons.search_light_outline,
    ),
    _ProfileItemData(
      title: 'پشتبانی',
      icon: Pelaicons.alarm_light_outline,
    ),
    _ProfileItemData(
      title: 'نمایندگی',
      icon: Pelaicons.group_1_light_outline,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.backgroundScreenColor,
        body: SafeArea(
          child: Column(
            children: [
              const AppbarWidget(title: 'حساب کاربری'),
              const Text(
                'جواد حیدری',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'SB',
                  color: Colors.black,
                ),
              ),
              const Gap(10),
              const Text(
                '------------',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const Gap(30),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  children: list
                      .map<ProfileItemWidgets>(
                        (element) =>
                            getProfileWidget(element.title, element.icon),
                      )
                      .toList(),
                ),
              ),
              const Spacer(),
              AuthenticationBottomWidget(
                title: 'خروج از حساب کاربری',
                size: const Size(200, 50),
                onPressed: () {
                  AuthManagment.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const Gap(20),
              const Column(
                children: [
                  Text(
                    'اپل شاپ',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'SM',
                      color: AppColor.gray,
                    ),
                  ),
                  Text(
                    'v-1.0.00',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'SM',
                      color: AppColor.gray,
                    ),
                  ),
                  Text(
                    'Telegram : t.me/JavadHeiDev',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'SM',
                      color: AppColor.gray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ProfileItemWidgets getProfileWidget(String title, IconData icon) {
  return ProfileItemWidgets(title: title, icon: icon);
}

class ProfileItemWidgets extends StatelessWidget {
  const ProfileItemWidgets({
    required this.title,
    required this.icon,
  });
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: ShapeDecoration(
            color: AppColor.blue,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            shadows: const [
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 25,
                offset: Offset(0.0, 10),
                spreadRadius: -15,
              )
            ],
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: Icon(
                icon,
                color: AppColor.white,
              ),
            ),
          ),
        ),
        const Gap(5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'SB',
            fontSize: 12,
          ),
        )
      ],
    );
  }
}

class _ProfileItemData {
  final String title;
  final IconData icon;
  _ProfileItemData({required this.title, required this.icon});
}
