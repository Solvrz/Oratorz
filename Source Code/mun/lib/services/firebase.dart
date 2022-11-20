// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '/config/constants.dart';

class CloudFirestore {
  static bool isDoc(String path) => path.split("/").length % 2 == 0;

  static bool isCollection(String path) => path.split("/").length % 2 == 1;

  static dynamic refAt(String path) {
    final List<String> labels = path.split("/");

    dynamic current = firestore;

    for (int index = 0; index < labels.length; index++) {
      if (index % 2 == 0) {
        current = current.collection(labels[index]);
      } else {
        current = current.doc(labels[index]);
      }
    }

    return current;
  }

  static Future<Stream<dynamic>> snapshots(
    String path, {
    String orderBy = "",
    bool? descending,
  }) async {
    if (orderBy.isNotEmpty && isCollection(path)) {
      return (descending == null
          ? refAt(path).orderBy(orderBy).snapshots()
          : refAt(path)
              .orderBy(orderBy, descending: descending)
              .snapshots()) as Future<Stream>;
    }

    return refAt(path).snapshots() as Future<Stream>;
  }

  static Future<dynamic> get(String path, {String orderBy = ""}) async {
    if (orderBy.isNotEmpty && isCollection(path)) {
      return refAt(path).orderBy(orderBy).get();
    }

    return refAt(path).get();
  }

  static Future<DocumentReference> add(
    String path,
    Map<String, dynamic> data,
  ) async {
    if (isCollection(path)) {
      return await refAt(path).add(data) as DocumentReference;
    } else {
      throw ErrorDescription("The path provided should lead to a collection.");
    }
  }

  static void set(String path, Map<String, dynamic> data) {
    if (isDoc(path)) {
      refAt(path).set(data);
    } else {
      throw ErrorDescription("The path provided should lead to a doc.");
    }
  }

  static void update(String path, Map<String, dynamic> data) {
    if (isDoc(path)) {
      refAt(path).update(data);
    } else {
      throw ErrorDescription("The path provided should lead to a doc.");
    }
  }
}

class CloudStorage {
  /// Uploads the [file] at the [path]. Returns a [TaskSnapshot]
  static Future<TaskSnapshot> uploadFile(String path, File file) =>
      storage.ref(path).putFile(file);

  /// Uploads the [data] at the [path]. Returns a [TaskSnapshot]
  static Future<TaskSnapshot> uploadData(String path, Uint8List data) =>
      storage.ref(path).putData(data);

  /// Deletes the file at [path]
  static Future<void> delete(String path) => storage.ref(path).delete();

  /// Deletes the file at [url]
  static Future<void> deleteUrl(String url) => storage
      .ref(
        url
            .replaceAll(
              RegExp(
                "https://firebasestorage.googleapis.com/v0/b/munsoft37.appspot.com/o/",
              ),
              "",
            )
            .replaceAll(RegExp("%2F"), "/")
            .replaceAll(RegExp(r"(\?alt).*"), "")
            .replaceAll(RegExp("%20"), " ")
            .replaceAll(RegExp("%3A"), ":")
            .replaceAll(RegExp("%2C"), ",")
            .replaceAll(RegExp("%3D"), "="),
      )
      .delete();

  /// Returns the upload progress of [task]
  static double progress(TaskSnapshot task) =>
      task.bytesTransferred / task.totalBytes;

  /// Returns the upload progress of [task] in percentage
  static double progressPercent(TaskSnapshot task) =>
      task.bytesTransferred / task.totalBytes * 100;
}
