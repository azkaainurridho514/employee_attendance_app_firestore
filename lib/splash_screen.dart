import 'package:employee_attendance/auth/login.dart';
import 'package:employee_attendance/core/assets/icons.dart';
import 'package:employee_attendance/core/assets/images.dart';
import 'package:employee_attendance/core/constant/widget.dart';
import 'package:employee_attendance/home/home.dart';
import 'package:employee_attendance/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/colors/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthProvider _auth;

  @override
  void initState() {
    super.initState();
    _auth = context.read<AuthProvider>();
    _auth.addListener(_onAuthLoaded);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _auth.loadUserFromLocal();
    });
  }

  bool _navigated = false;
  void _onAuthLoaded() async {
    if (!mounted || _navigated) return;
    _navigated = true;
    final user = _auth.user;
    _auth.removeListener(_onAuthLoaded);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    if (user == null || user.name.isEmpty) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthLoaded);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Stack(
        children: [
          Image.asset(
            MyImages.bgSplashScreen,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          textRandom(
                            text: "Sistem Absen",
                            size: 15,
                            color: Colors.white,
                          ),
                          textRandom(
                            text: "RUMAH GROSIR KUNINGAN",
                            size: 19,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Image.asset(
                        MyIcons.logoPNG,
                        width: MediaQuery.sizeOf(context).width * 0.7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
