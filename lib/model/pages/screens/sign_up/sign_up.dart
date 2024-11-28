import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_cap/core/size/size.dart';
import 'package:coffee_cap/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/assets.dart';
import '../../../../core/colors/color.dart';
import '../sign_In/sign_in.dart';
import '../../widget_small/custom_button.dart';
import '../../widget_small/text_form_field.dart';
import 'package:coffee_cap/services/authentication/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:coffee_cap/services/firestore/firestore_repository.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthenticationRepository _authRepository = AuthenticationRepository(
    FirebaseAuth.instance,
    GoogleSignIn(),
    FirestoreRepository(FirebaseFirestore.instance),
  );

  bool obscureText = true;
  bool isLoading = false;

  Future<void> _signUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCredential =
          await _authRepository.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Cập nhật tên hiển thị
      await _authRepository.updateDisplayName(_nameController.text.trim());

      // Chuyển đến màn hình chính
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: context.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Asset.bgBackground),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  "Create Account",
                  style: context.theme.textTheme.headlineLarge?.copyWith(
                    color: Styles.blueIcon,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFieldd(
                  controller: _nameController,
                  hintText: "Full Name",
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Styles.blueIcon,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFieldd(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Styles.blueIcon,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextFieldd(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Styles.blueIcon,
                  ),
                  obscureText: obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Styles.blueIcon,
                    ),
                    onPressed: () {
                      setState(() => obscureText = !obscureText);
                    },
                  ),
                ),
                const SizedBox(height: 30),
                CusButton(
                  text: "Sign Up",
                  color: Styles.blueIcon,
                  onPressed: isLoading ? () {} : _signUp,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        color: Styles.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Sign In",
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: Styles.blueIcon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

class CustomTextFieldd extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const CustomTextFieldd({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.obscureText,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Styles.defaultPadding),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Styles.blueLight.withOpacity(0.5),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Styles.blueIcon,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
