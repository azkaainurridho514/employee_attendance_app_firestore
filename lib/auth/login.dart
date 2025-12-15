import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance/core/constant/widget.dart';
import 'package:employee_attendance/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/assets/icons.dart';
import '../core/assets/images.dart';
import '../core/colors/colors.dart';
import '../home/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isRegister = false;
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AuthProvider>().loadUserFromLocal();
    // });
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Stack(
        children: [
          Image.asset(
            MyImages.bgSplashScreen,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: statusBarHeight),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: textRandom(
                  text: "RGK Absensi",
                  size: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Image.asset(
                  MyIcons.logoPNG,
                  width: MediaQuery.sizeOf(context).width * 0.45,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isRegister
                      ? TextField(
                        controller: username,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: MyColors.border,
                              width: 1,
                            ),
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: MyColors.primary,
                              width: 1,
                            ),
                          ),
                        ),
                      )
                      : const SizedBox(),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: password,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.border,
                          width: 1,
                        ),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: MyColors.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Consumer<AuthProvider>(
                    builder: (context, prov, child) {
                      if (!isRegister) {
                        if (prov.user != null && prov.message.isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastHelper.showSuccess(
                              context: context,
                              title: prov.message,
                            );
                            context.read<AuthProvider>().setMessage("");
                            context.read<AuthProvider>().setLoading(false);
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                              (route) => false,
                            );
                          });
                        } else if (prov.message.isNotEmpty && !prov.isLoading) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ToastHelper.showError(
                              context: context,
                              title: prov.message,
                            );
                            context.read<AuthProvider>().setLoading(false);
                            context.read<AuthProvider>().setMessage("");
                          });
                        }
                      }
                      return GestureDetector(
                        onTap:
                            () =>
                                !prov.isLoading
                                    ? isRegister
                                        ? prov.registerUser(
                                          context,
                                          username: username.text,
                                          email: email.text,
                                          password: password.text,
                                        )
                                        : prov.loginUser(
                                          context,
                                          email: email.text,
                                          password: password.text,
                                        )
                                    : null,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyColors.primary,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: MediaQuery.sizeOf(context).width,
                          child:
                              prov.isLoading
                                  ? Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        backgroundColor: MyColors.border,
                                      ),
                                    ),
                                  )
                                  : textRandom(
                                    text: isRegister ? "Daftar" : "login",
                                    size: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                        ),
                      );
                    },
                  ),
                  Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textRandom(
                        text:
                            isRegister
                                ? "Sudah punya akun?"
                                : "Belum punya akun?",
                        size: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                      GestureDetector(
                        onTap: () => setState(() => isRegister = !isRegister),
                        child: textRandom(
                          text: isRegister ? "Login" : "Register",
                          size: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
