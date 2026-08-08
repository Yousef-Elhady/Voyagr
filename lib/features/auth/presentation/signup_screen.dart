import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/core/widgets/Logo.dart';
import 'package:ai_travel/core/widgets/app_button.dart';
import 'package:ai_travel/core/widgets/divider.dart';
import 'package:ai_travel/core/widgets/socialMedia.dart';
import 'package:ai_travel/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  dynamic agreeWithTirm = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Logotext(title: "Voyagr"),
              SizedBox(height: 20),
              Text(
                "Start Planing Your next Adventure With AI",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              AuthTextField(
                controller: username,
                hint: "ziad elsayed",
                label: "Full Name ",
                iconData: Icons.person_2_outlined,
              ),
              AuthTextField(
                controller: email,
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
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.deepOrangeAccent,
                    value: agreeWithTirm,
                    onChanged: (value) {
                      setState(() {
                        agreeWithTirm = value;
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
              SizedBox(height: 20),
              AppButton(
                title: 'Create Account ',
                ontap: () {
                  context.push(RouteNames.login);
                },
              ),
              SizedBox(height: 10),
              OrDivider(),
              SizedBox(height: 10),

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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Text("Already have an Account ?"),
                    GestureDetector(
                      onTap: () => context.push(RouteNames.login),
                      child: Text(
                        " Log In ",
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
