import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/home.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/screens/authenication/login_screen.dart';

class SplashSreen extends StatefulWidget {
  const SplashSreen({super.key});

  @override
  State<SplashSreen> createState() => _SplashScreenPage();
}

class _SplashScreenPage extends State<SplashSreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 2), () {
      _redirect();
    });
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const HomePage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const LoginPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 80,
              color: Colors.greenAccent.shade400,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Mahatma Academy",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.greenAccent.shade400,
                fontSize: 32,
              ),
            )
          ],
        ),
      ),
    );
  }
}
