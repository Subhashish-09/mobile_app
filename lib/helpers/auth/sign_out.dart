import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/helpers/auth/google_sign_in.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/screens/authenication/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> signOut(context, mounted) async {
  try {
    await googleSignInData.signOut();

    await supabase.auth.signOut();
  } on AuthException catch (error) {
    SnackBar(
      content: Text(error.message),
      backgroundColor: Colors.red,
    );
  } catch (error) {
    const SnackBar(
      content: Text('Unexpected error occurred'),
      backgroundColor: Colors.red,
    );
  } finally {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (ctx) => const LoginPage(),
        ),
      );
    }
  }
}
