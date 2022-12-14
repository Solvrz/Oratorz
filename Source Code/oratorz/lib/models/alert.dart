import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/tools/enums.dart';
import '/tools/extensions.dart';

const List<Map<String, dynamic>> icons = [
  {
    "type": AlertType.Urgent,
    "icon": Icon(
      Icons.notification_important_outlined,
      color: Colors.amber,
    )
  },
  {
    "type": AlertType.Error,
    "icon": Icon(
      Icons.error_outline,
      color: Colors.red,
    )
  },
  {
    "type": AlertType.Infoformation,
    "icon": Icon(
      Icons.info_outline,
      // TODO: Change This
      // color: AlerColors.buttonColor,
    )
  },
  {
    "type": AlertType.Update,
    "icon": Icon(
      Icons.update_outlined,
      color: Colors.green,
    )
  },
  {
    "type": AlertType.Notification,
    "icon": Icon(
      Icons.notifications_active_outlined,
      color: Colors.white,
    )
  },
];

class Alert {
  final String message;
  final Timestamp time;
  final AlertType type;
  final Icon icon;
  final DocumentReference reference;

  Alert({
    required this.message,
    required this.type,
    required this.time,
    required this.icon,
    required this.reference,
  });

  void delete() => reference.delete();

  factory Alert.fromDoc(DocumentSnapshot doc) {
    final AlertType _type = (doc.get("type") as String).toAlertType();

    return Alert(
      message: doc.get("message") as String,
      type: _type,
      time: doc.get("time") as Timestamp,
      icon: icons.where((data) => data["type"] == _type).first["icon"]!,
      reference: doc.reference,
    );
  }

  static List<Alert> fromDocs(List<DocumentSnapshot> docs) {
    final List<Alert> _alerts = [];
    for (final DocumentSnapshot doc in docs) {
      _alerts.add(Alert.fromDoc(doc));
    }

    return _alerts;
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "type": type.toText(),
        "time": time,
        "reference": reference,
      };
}
