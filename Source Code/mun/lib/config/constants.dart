import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/profile.dart';

late ThemeData theme;
late Profile profile;

late FirebaseAuth auth;
late FirebaseFirestore firestore;
late FirebaseStorage storage;
late FirebaseAnalytics analytics;

const bool TESTING = kDebugMode;
const String IP = "192.168.100.45";
const Locale LOCALE = Locale("en", "IN");
