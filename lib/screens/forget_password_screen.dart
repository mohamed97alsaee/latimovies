import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latimovies/helpers/consts.dart';
import 'package:latimovies/main.dart';
import 'package:latimovies/providers/auth_provider.dart';
import 'package:latimovies/widgets/clickables/main_button.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Forget Password",
                    style: largeTitle,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Email Cannot Be Empty.";
                      }

                      if (!v.contains("@") || !v.contains(".")) {
                        return "Please Enter Valid Email.";
                      }

                      return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  MainButton(
                      label: "Reset Password",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Provider.of<AutheticationProvider>(context,
                                  listen: false)
                              .resetPassword(emailController.text)
                              .then((sent) {
                            if (sent) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const ScreenRouter()),
                                  (route) => false);
                            }
                          });
                        } else {
                          print("FORM IS NOT VALID");
                        }
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
