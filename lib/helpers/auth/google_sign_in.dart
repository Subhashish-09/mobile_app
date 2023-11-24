import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:sign_button/sign_button.dart';

final GoogleSignIn googleSignInData = GoogleSignIn(
  serverClientId:
      '29561126427-1m13gfgrlg1vhsv45ub7bt4a714vqad3.apps.googleusercontent.com',
  scopes: [
    'email',
    'openid',
    'profile',
  ],
);

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.google,
      onPressed: () async {
        final googleUser = await googleSignInData.signIn();

        final googleAuth = await googleUser!.authentication;

        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No Access Token found.';
        }

        if (idToken == null) {
          throw 'No ID Token found.';
        }

        await supabase.auth.signInWithIdToken(
          provider: Provider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
      },
      buttonSize: ButtonSize.large,
      btnText: "Continue with Google",
      padding: 8.5,
    );
  }
}
