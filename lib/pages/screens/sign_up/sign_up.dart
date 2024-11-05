import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';
import '../../../core/assets.dart';
import '../../../core/colors/color.dart';
import '../sign_In/sign_in.dart';
import '../../widget_small/custom_button.dart';
import '../../widget_small/text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _passwordController = TextEditingController();

  bool obscurrentText = true;

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Styles().hideKeyBoard(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: context.height,
                // width: context.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Asset.bgBackground),
                        fit: BoxFit.fill)),
              ),
              Positioned(
                top: context.height * 0.1,
                bottom: context.height * 0.1,
                left: context.width * 0.25,
                right: context.width * 0.25,
                child: Container(
                  height: context.height * 0.8,
                  width: context.width * 0.5,
                  padding: EdgeInsets.only(top: Styles.defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Styles.light,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Styles.blue.withOpacity(0.2),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Register",
                        style: context.theme.textTheme.headlineLarge?.copyWith(
                            color: Styles.blueIcon,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                      Text("Create your new account",
                          style: context.theme.textTheme.headlineSmall
                              ?.copyWith(fontSize: 18, color: Styles.grey)),
                      SizedBox(
                        height: context.height * 0.05,
                      ),
                      CustomTextField(
                        hintText: "Full Name",
                        prefixIcon: const Icon(
                          Icons.account_circle,
                          color: Styles.blueIcon,
                        ),
                        bg: Styles.blueLight.withOpacity(0.5),
                        colorText: Styles.blueIcon,
                      ),
                      SizedBox(
                        height: context.height * 0.015,
                      ),
                      CustomTextField(
                        hintText: "Enter email",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Styles.blueIcon,
                        ),
                        bg: Styles.blueLight.withOpacity(0.5),
                        colorText: Styles.blueIcon,
                      ),
                      SizedBox(
                        height: context.height * 0.015,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) =>
                              value!.isEmpty ? "Endter password" : null,
                          controller: _passwordController,
                          obscureText: obscurrentText,
                          decoration: InputDecoration(
                            filled: true, // Cho phép tô màu nền
                            fillColor: Styles.blueLight.withOpacity(0.5),
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)), // Bo góc
                              borderSide: BorderSide.none, // Loại bỏ viền
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_rounded,
                              size: 30,
                              color: Styles.blueIcon,
                            ),
                            hintText: "Enter password",
                            hintStyle: const TextStyle(
                              color: Styles.blueIcon,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            // labelText: "Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscurrentText = !obscurrentText;
                                });
                              },
                              child: Icon(
                                obscurrentText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Styles.blueIcon,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Styles.defaultPadding),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isChecked = !_isChecked;
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _isChecked
                                          ? Styles.blueIcon
                                          : Colors.grey.shade200,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: _isChecked
                                          ? const Icon(
                                              Icons.check,
                                              size: 20.0,
                                              color: Styles.light,
                                            )
                                          : Icon(
                                              Icons.circle,
                                              size: 20.0,
                                              color: Colors.grey.shade200,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    "Remember me",
                                    style: context.theme.textTheme.titleMedium
                                        ?.copyWith(
                                            color: Styles.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot your password?",
                                  style: context.theme.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Styles.blueIcon, fontSize: 14),
                                ))
                          ],
                        ),
                      ),
                      CusButton(
                           text: "Sign Up",
                          color: Styles.blueIcon, onPressed: () {  },),
                      SizedBox(
                        height: context.height * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 2,
                            width: context.width * 0.15,
                            color: Styles.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Or continue with",
                                style: context.theme.textTheme.headlineSmall
                                    ?.copyWith(
                                        fontSize: 18, color: Styles.grey)),
                          ),
                          Container(
                            height: 2,
                            width: context.width * 0.15,
                            color: Styles.grey,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: context.height * 0.02,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(Asset.iconFb),
                            backgroundColor: Styles.light,
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(Asset.iconGg),
                            backgroundColor: Styles.light,
                          ),
                          Spacer(),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(Asset.iconIp),
                            backgroundColor: Styles.light,
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: context.height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Styles.defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You already have an account",
                              style: context.theme.textTheme.titleMedium,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignIn(),
                                      ));
                                },
                                child: Text(
                                  "Sign In",
                                  style: context.theme.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Styles.blueIcon,
                                          fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
