import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/core/widgets/Logo.dart';
import 'package:ai_travel/core/widgets/app_button.dart';
import 'package:ai_travel/core/widgets/divider.dart';
import 'package:ai_travel/core/widgets/socialMedia.dart';
import 'package:ai_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:ai_travel/features/auth/application//auth_controller.dart';
import 'package:ai_travel/features/auth/application//auth_state.dart';
import 'package:ai_travel/features/auth/presentation/widgets/validation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController NameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  bool agreeWithTerms = true;

  @override
  void initState() {
    super.initState();

    NameController = TextEditingController();
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
    NameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
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
                Logotext(title: "Voyagr"),

                const SizedBox(height: 20),

                const Text(
                  "Start Planning Your Next Adventure With AI",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: NameController,
                  hint: "Marwan",
                  label: "Name",
                  iconData: Icons.person_outline,
                  validator: (value) => validateName(value),
                ),
                AuthTextField(
                  controller: emailController,
                  hint: "explorer@gmail.com",
                  label: "Email Address",
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

                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.deepOrangeAccent,
                      value: agreeWithTerms,
                      onChanged: (value) {
                        setState(() {
                          agreeWithTerms = value ?? false;
                        });
                      },
                    ),

                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(text: "I agree to the "),
                            TextSpan(
                              text: "Terms of Service",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            ),
                            TextSpan(text: " and "),
                            TextSpan(
                              text: "Privacy Policy.",
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                AppButton(
                  title: isLoading ? 'Creating Account...' : 'Create Account',
                  ontap: () {
                    if (isLoading) return;
                    if (!_formKey.currentState!.validate()) return;
                    if (!agreeWithTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please agree to the Terms of Service.',
                          ),
                        ),
                      );
                      return;
                    }

                    final Name = NameController.text.trim();

                    final email = emailController.text.trim();

                    final password = passwordController.text;

                    if (Name.isEmpty || email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields.'),
                        ),
                      );
                      return;
                    }

                    ref
                        .read(authControllerProvider.notifier)
                        .register(name: Name, email: email, password: password);
                  },
                ),

                const SizedBox(height: 10),

                OrDivider(),

                const SizedBox(height: 10),

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

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      const Text("Already have an Account?"),

                      GestureDetector(
                        onTap: () => context.push(RouteNames.login),
                        child: const Text(
                          " Log In",
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
