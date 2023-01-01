import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/ui/widgets/rounded_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.all(5),
            child: Image.asset("images/Logo.png"),
          ),
          title: RichText(
            text: TextSpan(
              text: "Oratorz",
              style: context.textTheme.headline5?.copyWith(color: Colors.white),
              children: [
                TextSpan(
                  text: "\nA Unit of Solvrz Inc.",
                  style: context.textTheme.caption,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Error 404",
                          style: context.textTheme.headline1,
                          children: [
                            TextSpan(
                              text:
                                  "\n\nPage Not Found!\nThe page you are looking for\ncould not be found.\nPlease go back!",
                              style: context.textTheme.headline5
                                  ?.copyWith(fontSize: 36),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    height: context.height / 2,
                    width: context.width / 1.75,
                    "images/Error.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: context.width / 2,
                child: RoundedButton(
                  child: Text(
                    "Go Back",
                    style: context.textTheme.headline5
                        ?.copyWith(color: Colors.white),
                  ),
                  onPressed: () => context.pushReplacement("/"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
