import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/config/constants.dart';
import '/services/auth.dart';
import '/tools/extensions.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with RestorationMixin {
  @override
  String? get restorationId => "signin";

  late final RestorableTextEditingController _emailContoller;
  late final RestorableTextEditingController _passwordContoller;

  @override
  void initState() {
    super.initState();

    if (auth.currentUser != null) {
      Auth.login(
        context,
        () async => context.go("/"),
      );
    }

    _emailContoller = RestorableTextEditingController();
    _passwordContoller = RestorableTextEditingController();
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_emailContoller, "email");
    registerForRestoration(_passwordContoller, "password");
  }

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordContoller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextField(
            controller: _emailContoller.value,
            decoration: InputDecoration(
              hintText: "Email",
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]!),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]!),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // TODO: Hide Text & Extract Field
          TextField(
            controller: _passwordContoller.value,
            decoration: InputDecoration(
              hintText: "Password",
              counterText: "Forgot password?",
              suffixIcon: const Icon(
                Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]!),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]!),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple[100]!,
                  spreadRadius: 10,
                  blurRadius: 20,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                await auth.signInWithEmailAndPassword(
                  email: _emailContoller.text().toLowerCase(),
                  password: _passwordContoller.text(),
                );

                if (mounted) {
                  await Auth.login(
                    context,
                    () async => context.go("/"),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text("Sign In"),
                ),
              ),
            ),
          ),
        ],
      );
}
