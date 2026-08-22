import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/core/widgets/Logo.dart';
import 'package:ai_travel/core/widgets/app_button.dart';
import 'package:ai_travel/core/widgets/divider.dart';
import 'package:ai_travel/core/widgets/socialMedia.dart';
import 'package:ai_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:ai_travel/features/auth/presentation/widgets/validation_controller.dart';
import 'package:flutter/material.dart';
import 'package:ai_travel/features/auth/application//auth_controller.dart';
import 'package:ai_travel/features/auth/application//auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    ref.listenManual<AuthState>(authControllerProvider, (previous, next) {
      if (!mounted) return;

      if (next is AuthStateAuthenticated) {
        context.go(RouteNames.home);
      }

      if (next is AuthStateError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState is AuthStateLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Logotext(title: "Voyagr"),
                SizedBox(height: 20),
                Text(
                  "Welcome Back ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 10),
                Text("Sign in to Continue your Journey"),
                SizedBox(height: 20),
                AuthTextField(
                  controller: emailController,
                  hint: "explorer@gmail.com",
                  label: "Email Adderss",
                  iconData: Icons.email_outlined,
                  validator: (value) => validateEmail(value),
                ),
                AuthTextField(
                  isPassword: true,
                  controller: passwordController,
                  hint: "..........",
                  label: "Password",
                  iconData: Icons.lock_outline,
                  validator: (value) => validatePassword(value),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "forget Password?",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AppButton(
                  title: isLoading ? 'Signing in... ' : 'Sign In ',
                  ontap: () {
                    if (isLoading) return;
                    if (!_formKey.currentState!.validate()) return;
                    final email = emailController.text.trim();
                    final password = passwordController.text;

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter your email and password.',
                          ),
                        ),
                      );
                      return;
                    }
                    ref
                        .read(authControllerProvider.notifier)
                        .login(email: email, password: password);
                  },
                ),

                SizedBox(height: 10),
                OrDivider(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    UsingSocialmedia(
                      icon: "assets/icons/google_icon.svg",
                      ontap: () {},
                      methodname: 'Google',
                    ),
                    UsingSocialmedia(
                      icon: "assets/icons/apple_icon.svg",
                      ontap: () {},
                      methodname: 'Apple',
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Text("Don't Have an Account ?"),
                      GestureDetector(
                        onTap: () => context.push(RouteNames.signup),
                        child: Text(
                          "Sign UP ",
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
