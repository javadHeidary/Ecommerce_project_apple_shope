import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/screens/login_screen.dart';
import 'package:shop/screens/register_screen.dart';
import 'package:shop/util/Extensions/string_extension.dart';

class AuthenticationBottomWidget extends StatelessWidget {
  const AuthenticationBottomWidget({
    super.key,
    required this.title,
    this.text,
    this.size = const Size(350, 50),
    required this.onPressed,
  });
  final String title;
  final Size? size;
  final String? text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.blueIndicator,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: size,
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'sb',
              color: AppColor.white,
            ),
          ),
        ),
        const Gap(10),
        if (text.isValid()) ...[
          RichText(
            text: TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'sm',
                color: AppColor.gray,
              ),
              children: [
                TextSpan(
                  text: (title == 'ورود') ? ' ثبت نام' : ' ورود',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'sm',
                    color: AppColor.blueIndicator,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => title == 'ورود'
                              ? const RegisterScreen()
                              : const LoginScreen(),
                        ),
                      );
                    },
                ),
              ],
            ),
          )
        ],
      ],
    );
  }
}
