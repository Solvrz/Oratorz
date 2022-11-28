import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '/config/colors.dart';
import '/config/constants.dart';
import '/models/profile.dart';
import './firebase.dart';
import './user_manager.dart';

// ignore: avoid_classes_with_only_static_members
class Auth {
  static Future<List<Map<String, dynamic>>> handleErrors({
    required bool otpSent,
    required List<Map<String, dynamic>> fieldInfo,
    required FirebaseAuthException error,
    required StackTrace stack,
  }) async {
    String msg;

    switch (error.code) {
      case "invalid-phone-number":
        msg = "Wrong Contact No.";
        break;
      case "invalid-verification-code":
        msg = "Wrong OTP";
        break;
      case "invalid-verification-id":
        msg = "Wrong OTP";
        break;

      case "too-many-requests":
        msg = "Too many unsuccessful attempts. Try Again Later...";
        break;
      case "operation-not-allowed":
        msg = "Operation not allowed. Try Again Later...";
        break;
      case "session-expired":
        msg = "Session Expired, Resend OTP & Try Again";
        break;
      default:
        {
          msg = "An Undefined Error Occurred, Contact Us!";
        }
    }

    fieldInfo
        .where(
          (field) =>
              field["value"] == ("otp") || field["value"] == "contact_no",
        )
        .forEach((field) => field["error"] = msg);

    return fieldInfo;
  }

  static Future<void> onSignUp({
    required BuildContext context,
    required PhoneAuthCredential credential,
    required num contactNo,
    required void Function() onComplete,
  }) async {
    final String _user = "users/${auth.currentUser!.uid}";
    final bool _userExists = (await CloudFirestore.get(_user)).exists;
    if (!_userExists) CloudFirestore.set(_user, {"contactNo": contactNo});

    await UserManager.addUser(
      id: auth.currentUser!.uid,
      name: "",
      email: "",
      contactNo: contactNo,
    );

    onComplete();
  }

  static Future<void> login(
    BuildContext context,
    void Function() onLoggedIn,
  ) async {
    if (auth.currentUser != null) {
      try {
        profile = await Profile.fromID(auth.currentUser!.uid);

        // TODO: Do This
        // alerts = Alert.fromDocs(
        //   (await profile.reference.collection("alerts").get()).docs,
        // )..addAll(
        //     Alert.fromDocs(
        //       (await CloudFirestore.get("alerts") as QuerySnapshot).docs,
        //     ),
        //   );

        await analytics.setUserId(id: auth.currentUser!.uid);
        await analytics.logLogin();
      } catch (error) {
        await Dialogs.materialDialog(
          context: context,
          msgAlign: TextAlign.center,
          color: OratorzColors.PrimaryColor,
          title: "An Error Occured",
          msg: "Try Again Later Or Contact Us\n\n$error",
          actions: [
            IconsButton(
              text: "Okay",
              iconData: Icons.check_circle_outline_outlined,
              textStyle: const TextStyle(color: Colors.white),
              onPressed: () async {
                await Auth.logout(
                  context,
                  () async => context.goNamed("/"),
                );
              },
            ),
          ],
        );

        return;
      }
    }

    onLoggedIn();
  }

  static Future<void> logout(
    BuildContext context,
    void Function() onLoggedOut,
  ) async {
    await UserManager.clearUsers();
    await auth.signOut();

    onLoggedOut();
  }
}
