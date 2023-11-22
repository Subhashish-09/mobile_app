import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  try {
    await Supabase.initialize(
      url: 'https://auth.mahatmaacademy.com',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.ewogICJyb2xlIjogImFub24iLAogICJpc3MiOiAic3VwYWJhc2UiLAogICJpYXQiOiAxNjk2OTYyNjAwLAogICJleHAiOiAxODU0ODE1NDAwCn0.rllXp3hZj1v8Uw8qbpKrZPChUTqlpwSCCCtzkqJkYcM',
      authFlowType: AuthFlowType.pkce,
    );
  } on Exception catch (_) {}

  runApp(
    const MyApp(),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashSreen(),
    );
  }
}
