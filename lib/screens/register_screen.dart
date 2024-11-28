import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:shop/bloc/authentication/authentication_bloc.dart';
import 'package:shop/di/di.dart';
import 'package:shop/res/app_color.dart';
import 'package:shop/res/app_svg.dart';
import 'package:shop/screens/dashboard_screen.dart';
import 'package:shop/util/feedback_handler.dart';
import 'package:shop/widgets/animation_loding_widget.dart';
import 'package:shop/widgets/authentication_bottom_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passworConfirmController =
      TextEditingController();

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  final _userNameKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _passwordConfirmKey = GlobalKey<FormFieldState>();

  final ValueNotifier<bool> _obscureNotifire = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<AuthBloc>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.blueIndicator,
          body: BlocConsumer<AuthBloc, AuthState>(
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
                    Navigator.push(
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
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(70),
                      Container(
                        width: MediaQuery.of(context).size.width,
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
                              height: 90,
                              width: 90,
                              child: SvgPicture.asset(
                                AppSvg.apple,
                                color: AppColor.blueIndicator,
                              ),
                            ),
                            const Gap(20),
                            const Text(
                              'ایجاد حساب کاربری',
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
                                  key: _userNameKey,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: _userNameController,
                                  focusNode: _userNameFocusNode,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                  cursorColor: AppColor.blueIndicator,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: AppColor.backgroundScreenColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
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
                                  ' رمز  : ',
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
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      obscureText: _obscureNotifire.value,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).requestFocus(
                                            _passwordConfirmFocusNode);
                                      },
                                      cursorColor: AppColor.blueIndicator,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        fillColor:
                                            AppColor.backgroundScreenColor,
                                        filled: true,
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
                                        ),
                                        suffixIcon: IconButton(
                                          splashColor: Colors.black,
                                          hoverColor: Colors.blue,
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
                            const Gap(20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'تکرار رمز  : ',
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
                                      key: _passwordConfirmKey,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      controller: _passworConfirmController,
                                      focusNode: _passwordConfirmFocusNode,
                                      obscureText: _obscureNotifire.value,
                                      cursorColor: AppColor.blueIndicator,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        fillColor:
                                            AppColor.backgroundScreenColor,
                                        filled: true,
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
                                        ),
                                        suffixIcon: IconButton(
                                          splashColor: Colors.black,
                                          hoverColor: Colors.blue,
                                          onPressed: () {
                                            _obscureNotifire.value =
                                                !_obscureNotifire.value;
                                          },
                                          icon: Icon(
                                            _obscureNotifire.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
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
                                title: 'ثبت نام',
                                text: 'اگر حساب کاربری دارید /',
                                onPressed: () {
                                  if (_userNameKey.currentState!.validate() &&
                                      _passwordKey.currentState!.validate() &&
                                      _passwordConfirmKey.currentState!
                                          .validate()) {
                                    context.read<AuthBloc>().add(
                                          AuthRegisterRequest(
                                            _userNameController.text,
                                            _passwordController.text,
                                            _passworConfirmController.text,
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
                              ),
                            },
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _userNameFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _passworConfirmController.dispose();
    _passwordConfirmFocusNode.dispose();
  }
}
