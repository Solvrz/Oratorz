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
          leading: SvgPicture.asset("images/Logo.svg", color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Oratorz",
                style: context.textTheme.headlineSmall
                    ?.copyWith(color: Colors.white, height: 0.95),
              ),
              Text(
                "A Unit of Solvrz Inc.",
                style: context.textTheme.bodySmall
                    ?.copyWith(color: Colors.white, height: 0.95),
              ),
            ],
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      padding: const EdgeInsets.all(8),
                      backgroundColor: const Color(0xffafbfdc),
                      label: Text(
                        "Page not found",
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    Text(
                      "Oops! Error 404",
                      style: context.textTheme.displayLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "The page you are looking for could not be found. Please go back!",
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontSize: 26,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton(
                            child: Text(
                              "Back to Homepage",
                              style: context.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                            onPressed: () => context.pushReplacement("/home"),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: RoundedButton(
                            onPressed: () => context.pushReplacement("/help"),
                            border: true,
                            child: Text(
                              "Visit our Help Center",
                              style: context.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Image.asset(
                "images/Error.png",
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
