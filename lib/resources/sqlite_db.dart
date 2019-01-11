import 'package:sqflite/sqflite.dart';

// Handles all the sqlite operations 
// Used for 
// 1. offline caching shown until app is making request
//    which will be deleted on the first event get request after app opens
//    and refilled with new cache
// 2. For saved events, which will be completely stored in this database

