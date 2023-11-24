import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/auth/google_sign_in.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _redirecting = false;
  late final TextEditingController _emailController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const HomePage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SupaEmailAuth(
                    redirectTo: 'com.mahatmaacademy.android://login-callback',
                    onSignInComplete: (response) {},
                    onSignUpComplete: (response) {},
                    metadataFields: [
                      MetaDataField(
                        prefixIcon: const Icon(Icons.person),
                        label: 'Username',
                        key: 'username',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter something';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const GoogleSignInButton()
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
