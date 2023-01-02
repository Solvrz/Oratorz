import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

late final FirebaseAnalytics analytics;

const bool TESTING = kDebugMode;
const Locale LOCALE = Locale("en", "IN");

const List<String> INVITE_CODES = ["ORAOP0037"];
