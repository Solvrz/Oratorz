import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

const bool INVITE_CODES_ENABLED = false;
const bool TESTING = kDebugMode;

const List<String> INVITE_CODES = ["ORASI0037"];

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
