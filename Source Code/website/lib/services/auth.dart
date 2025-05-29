// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/models/account.dart';
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

  static Future<void> login(
    BuildContext context, {
    String? password,
    Function? onLoggedIn,
    bool pushToSplash = true,
    bool showError = true,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      if (auth.currentUser != null) {
        // TODO: Add account to local storage
      }

      if (onLoggedIn != null) onLoggedIn();

      if (pushToSplash) {
        if (context.mounted) {
          await Navigator.pushNamedAndRemoveUntil(
            context,
            "/",
            (_) => false,
          );
        }
      }
    } catch (e) {
      if (showError) {
        if (context.mounted) {
          // TODO : Show an error message
          // await showDialog(
          //   context: context,
          //   builder: (context) => RoundedAlertDialog(
          //     title: "An Error Occurred",
          //     description:
          //         "Please report the error to the administration.\n\nError: $e",
          //     descriptionSize: 18,
          //     buttonsList: [
          //       TextButton(
          //         onPressed: () => SystemNavigator.pop(),
          //         child: const Text("Okay"),
          //       ),
          //     ],
          //   ),
          // );
        }
      }
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

  static Future<void> logout(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    await AccountManager.clearAccount();
    await auth.signOut();

    if (context.mounted) {
      await Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    }
  }
}
