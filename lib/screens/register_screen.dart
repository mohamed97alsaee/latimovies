import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latimovies/helpers/consts.dart';
import 'package:latimovies/main.dart';
import 'package:latimovies/providers/auth_provider.dart';
import 'package:latimovies/widgets/clickables/main_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Craete Account",
                    style: largeTitle,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "name Cannot Be Empty.";
                      }

                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "name",
                        labelText: "name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 12,
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
                    height: 12,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password Cannot Be Empty.";
                      }

                      if (value.length < 8) {
                        return "Password Must Be At Least 8 Characters.";
                      }

                      return null;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  MainButton(
                      label: "Create",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Provider.of<AutheticationProvider>(context,
                                  listen: false)
                              .createAccount(nameController.text,
                                  emailController.text, passwordController.text)
                              .then((logedIn) {
                            if (logedIn) {
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
