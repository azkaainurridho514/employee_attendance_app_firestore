import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/firebase_options.dart';
import 'package:employee_attendance/providers/download_attendance_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/login.dart';
import 'core/colors/colors.dart';
import 'home/home.dart';
import 'providers/auth_provider.dart';
import 'providers/stream_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = Settings(
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AbsentProvider()),
        ChangeNotifierProvider(create: (_) => DownloadAttendanceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: MyColors.bg,
          colorScheme: ColorScheme.fromSeed(
            seedColor: MyColors.bg,
            primary: MyColors.bg,
          ),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
