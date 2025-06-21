// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '/models/account.dart';
import '/tools/controllers/signin.dart';
import '/tools/controllers/signup.dart';
import '/tools/functions.dart';
import './account.dart';

class Auth {
  static Future<Map<String, String>> handleErrors(String error) async {
    final Map<String, String> errors = {"user": "", "pass": ""};

    switch (error) {
      case "invalid-email":
        errors["user"] = "The username is wrong";
        break;
      case "user-not-found":
        errors["user"] = "The username is wrong";
        break;
      case "too-many-requests":
        errors["pass"] = "Too many unsuccessful attempts. Try again later..";
        break;
      case "wrong-password":
        errors["pass"] = "The password is wrong";
        break;
      default:
        errors["pass"] = "An undefined error occurred";
    }

    return errors;
  }

  static Future<bool> signin(BuildContext context) async {
    final SignInController controller = Get.find<SignInController>();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: controller.email.value,
        password: controller.password.value,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (context.mounted) {
          snackbar(
            context,
            const Center(
              child: Text(
                "No user found for the email provided. Please check and try again.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      } else if (e.code == 'wrong-password') {
        if (context.mounted) {
          snackbar(
            context,
            const Center(
              child: Text(
                "Wrong password provided for the user. Please check and try again.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }

      return false;
    } catch (e) {
      print(e);

      if (context.mounted) {
        snackbar(
          context,
          const Center(
            child: Text(
              "An unknown error occured. Please try again later or contact the support team.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      return false;
    }
  }

  static Future<void> changePassword(
    BuildContext context,
    String oldPass,
    String newPass,
    Function onError,
  ) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final Account account = (await AccountManager.account)!;

    await auth.currentUser!.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: account.email,
        password: account.password,
      ),
    );

    await auth.currentUser!.updatePassword(newPass).then(
      (_) async {
        await auth.currentUser!.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: account.email,
            password: newPass,
          ),
        );

        await AccountManager.addAccount(
          account.id,
          account.name,
          newPass,
          account.email,
          account.institution,
        );
      },
    ).catchError((_) => onError());
  }

  static Future<void> signout(BuildContext context) async {
    await AccountManager.clearAccount();
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      context.pushReplacement("/");
    }
  }

  static Future<bool> signup(BuildContext context) async {
    final SignUpController controller = Get.find<SignUpController>();

    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: controller.email.value,
        password: controller.password.value,
      );

      await credential.user!.updateDisplayName(
        "${controller.firstName.value} ${controller.lastName.value}",
      );

      await credential.user?.sendEmailVerification();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (context.mounted) {
          snackbar(
            context,
            const Center(
              child: Text(
                "The account already exists for the email provided. Please try signing in.",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }

      return false;
    } catch (e) {
      if (context.mounted) {
        snackbar(
          context,
          const Center(
            child: Text(
              "An unknown error occured. Please try again later or contact the support team.",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return false;
    }
  }
}
