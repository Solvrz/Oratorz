import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            child: SvgPicture.asset("images/Logo.svg"),
          ),
          title: Column(
            children: [
              // TODO: Improve Me
              Text(
                "Oratorz",
                style: context.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                "\nA Unit of Solvrz Inc.",
                style: context.textTheme.bodySmall,
              ),
            ],
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
                          style: context.textTheme.displayLarge,
                          children: [
                            TextSpan(
                              text:
                                  "\n\nPage Not Found!\nThe page you are looking for\ncould not be found.\nPlease go back!",
                              style: context.textTheme.headlineSmall
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
                    style: context.textTheme.headlineSmall
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
