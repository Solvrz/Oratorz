import 'package:flutter/material.dart';

import './widgets/login_form.dart';
import './widgets/menu.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFf5f5f5),
        body: SafeArea(
          child: Scrollbar(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 8,
              ),
              child: Column(
                children: [
                  Menu(
                    isSignIn: isSignIn,
                    setSignIn: (signIn) => setState(() => isSignIn = signIn),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${isSignIn ? "Sign In to" : "Register on"} \nOratorz",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Don't have an account?",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Colors.black54),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "Register here!",
                                style: TextStyle(
                                  fontSize: 20,
                                  // color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Image.asset(
                              "images/illustration2.png",
                              width: 300,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "images/illustration1.png",
                        width: 300,
                      ),
                      Container(
                        width: 320,
                        margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 6,
                        ),
                        // TODO: Register & CircularProgressIndicator
                        child: isSignIn ? const SignInForm() : Container(),
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
