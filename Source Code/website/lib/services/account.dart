// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import '/models/account.dart';
import './local_storage.dart';

class AccountManager {
  static Future<Account?> get account async {
    final element = await LocalStorage.box.read("account");

    return element != null ? Account.fromJson(element) : null;
  }

  static Future<void> addAccount(
    String id,
    String name,
    String password,
    String email,
    String institution,
  ) async {
    final account = Account(
      id: id,
      name: name,
      password: password,
      email: email,
      institution: institution,
    );

    await LocalStorage.box.write(
      "account",
      jsonEncode(account.toJson()),
    );
  }

  static Future<void> clearAccount() => LocalStorage.box.write("account", "");
}
