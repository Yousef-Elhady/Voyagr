import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/core/widgets/Logo.dart';
import 'package:ai_travel/core/widgets/app_button.dart';
import 'package:ai_travel/core/widgets/divider.dart';
import 'package:ai_travel/core/widgets/socialMedia.dart';
import 'package:ai_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailAdderss = TextEditingController();
    final TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
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
                controller: emailAdderss,
                hint: "explorer@gmail.com",
                label: "Email Adderss",
                iconData: Icons.email_outlined,
              ),
              AuthTextField(
                isPassword: true,
                controller: password,
                hint: "..........",
                label: "Password",
                iconData: Icons.lock_outline,
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
                title: 'Sign In',
                ontap: () {
                  context.push(RouteNames.home);
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
    );
  }
}
