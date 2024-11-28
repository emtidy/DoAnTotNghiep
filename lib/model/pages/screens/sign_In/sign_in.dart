import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:coffee_cap/services/firestore/firestore_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../../widget_small/custom_button.dart';
import '../../widget_small/text_form_field.dart';
import '../sign_up/sign_up.dart';
import 'package:coffee_cap/services/authentication/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationRepository _authRepository = AuthenticationRepository(
    FirebaseAuth.instance,
    GoogleSignIn(),
    FirestoreRepository(
        FirebaseFirestore.instance), // Implement your FirestoreRepository
  );

  bool obscurrentText = true;

  bool _isChecked = false;

  bool _isLoading = false;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      print('Attempting login with:');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');

      await _authRepository.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      print('Login successful');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Không tìm thấy tài khoản với email này';
          break;
        case 'wrong-password':
          message = 'Sai mật khẩu';
          break;
        case 'invalid-email':
          message = 'Email không hợp lệ';
          break;
        case 'invalid-credential':
          message =
              'Thông tin đăng nhập không chính xác vui lòng kiểm tra lại.';
          break;
        case 'user-disabled':
          message = 'Tài khoản đã bị vô hiệu hóa';
          break;
        case 'too-many-requests':
          message = 'Quá nhiều yêu cầu đăng nhập. Vui lòng thử lại sau';
          break;
        case 'operation-not-allowed':
          message = 'Đăng nhập bằng email và mật khẩu không được kích hoạt';
          break;
        case 'network-request-failed':
          message = 'Lỗi kết nối mạng';
          break;
        case 'invalid-verification-code':
          message = 'Mã xác thực không hợp lệ';
          break;
        case 'invalid-verification-id':
          message = 'ID xác thực không hợp lệ';
          break;
        case 'account-exists-with-different-credential':
          message = 'Tài khoản đã tồn tại với phương thức đăng nhập khác';
          break;
        default:
          print('Firebase Auth Error Code: ${e.code}');
          print('Firebase Auth Error Message: ${e.message}');
          message = 'Đã có lỗi xảy ra khi đăng nhập';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Đóng',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
                top: context.height * 0.25,
                bottom: context.height * 0.25,
                left: context.width * 0.25,
                right: context.width * 0.25,
                child: Container(
                  // margin: EdgeInsets.symmetric(
                  //    vertical: context.height*0.25),
                  height: context.height * 0.5,
                  width: context.width * 0.5,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: context.height * 0.015,
                        ),
                        Text(
                          "Welcome Back",
                          style: context.theme.textTheme.headlineLarge
                              ?.copyWith(
                                  color: Styles.blueIcon,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26),
                        ),
                        Text("Login to your account?",
                            style: context.theme.textTheme.headlineSmall
                                ?.copyWith(fontSize: 18, color: Styles.grey)),
                        SizedBox(
                          height: context.height * 0.04,
                        ),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!value.contains('@')) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                          prefixIcon: const Icon(
                            Icons.email,
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
                                value!.isEmpty ? "Nhap mật khẩu" : null,
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
                              // TextButton(
                              //     onPressed: () {},
                              //     child: Text(
                              //       "Forgot your password?",
                              //       style: context.theme.textTheme.titleMedium
                              //           ?.copyWith(
                              //               color: Styles.blueIcon, fontSize: 14),
                              //     ))
                            ],
                          ),
                        ),
                        CusButton(
                          text: _isLoading ? "Signing In..." : "Sign In",
                          color: Styles.blueIcon,
                          onPressed: _signIn,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Styles.defaultPadding),
                          // child: Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       "Don’t have an account?",
                          //       style: context.theme.textTheme.titleMedium,
                          //     ),
                          //     TextButton(
                          //         onPressed: () {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => const SignUp(),
                          //               ));
                          //         },
                          //         child: Text(
                          //           "Sign up",
                          //           style: context.theme.textTheme.titleMedium
                          //               ?.copyWith(
                          //                   color: Styles.blueIcon,
                          //                   fontWeight: FontWeight.bold),
                          //         )),
                          //   ],
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
