import 'package:flutter/material.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/screens/dashboard_screen.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
        top: 20,
        bottom: 30,
      ),
      height: 46,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    color: Colors.black,
                    Icons.chevron_left,
                    size: 20,
                    weight: 2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'SB',
                  color: AppColor.blue,
                ),
              ),
            ),
            const Icon(
              Icons.apple,
              color: AppColor.blue,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
