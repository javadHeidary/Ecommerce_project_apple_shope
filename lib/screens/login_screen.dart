import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shop/bloc/authentication/authentication_bloc.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/res/app_gif.dart';
import 'package:shop/screens/dashboard_screen.dart';
import 'package:shop/util/feedback_handler.dart';
import 'package:shop/widgets/animation_loding_widget.dart';
import 'package:shop/widgets/authentication_bottom_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final ValueNotifier<bool> _obscureNotifire = ValueNotifier(true);

  final _usernameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<AuthBloc>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.blueIndicator,
          body: SafeArea(
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthResponse) {
                    return state.response.fold(
                      (exception) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          FeedbackHandler.customSnackBar(
                              message: exception, color: AppColor.red),
                        );
                      },
                      (response) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          FeedbackHandler.customSnackBar(
                              message: response, color: AppColor.green),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(70),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 30,
                          left: 30,
                          bottom: 60,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 17,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.asset(AppGif.login),
                            ),
                            const Text(
                              'ورود به حساب کاربری',
                              style: TextStyle(
                                fontFamily: 'sm',
                                fontSize: 18,
                                color: AppColor.blue,
                              ),
                            ),
                            const Gap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'نام کاربری : ',
                                  style: TextStyle(
                                    fontFamily: 'sm',
                                    fontSize: 14,
                                    color: AppColor.black,
                                  ),
                                ),
                                const Gap(10),
                                TextFormField(
                                  key: _usernameKey,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: _userNameController,
                                  focusNode: _userNameFocusNode,
                                  cursorColor: AppColor.blueIndicator,
                                  keyboardType: TextInputType.name,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: AppColor.backgroundScreenColor,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'لطفا نام کاربری خود را وارد کنید';
                                    } else if (value.length < 3) {
                                      return 'نام کاربری باید حداقل ۳ کارکتر باشد';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                            const Gap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  ' رمز عبور : ',
                                  style: TextStyle(
                                    fontFamily: 'sm',
                                    fontSize: 14,
                                    color: AppColor.black,
                                  ),
                                ),
                                const Gap(10),
                                ValueListenableBuilder(
                                  valueListenable: _obscureNotifire,
                                  builder: (context, value, child) {
                                    return TextFormField(
                                      key: _passwordKey,
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      cursorColor: AppColor.blueIndicator,
                                      obscureText: _obscureNotifire.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        fillColor:
                                            AppColor.backgroundScreenColor,
                                        filled: true,
                                        contentPadding: const EdgeInsets.only(
                                          top: 12,
                                          right: 10,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            _obscureNotifire.value =
                                                !_obscureNotifire.value;
                                          },
                                          icon: Icon(
                                            _obscureNotifire.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'لطفا رمز عبور را وارد کنید';
                                        } else if (value.length < 8) {
                                          return 'رمز عبور باید حداقل ۸ کاراکتر باشد';
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Gap(40),
                            if (state is AuthLoading) ...{
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.blueIndicator,
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  minimumSize: const Size(350, 50),
                                ),
                                onPressed: () {},
                                child: AnimationLoding.threeBounce(),
                              ),
                            } else ...{
                              AuthenticationBottomWidget(
                                title: 'ورود',
                                text: 'اگر هنوز ثبت نام نکردید /',
                                onPressed: () {
                                  if (_usernameKey.currentState!.validate() &&
                                      _passwordKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          AuthLoginRequest(
                                            _userNameController.text,
                                            _passwordController.text,
                                          ),
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      FeedbackHandler.customSnackBar(
                                          color: AppColor.red,
                                          message:
                                              'لطفا موارد خواسته شده را تکمیل کنید'),
                                    );
                                  }
                                },
                              )
                            }
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userNameFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
