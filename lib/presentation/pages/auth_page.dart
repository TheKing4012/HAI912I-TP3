import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../widgets/login_card.dart';
import '../widgets/signup_card.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLogin ? LoginWidget(onSwitch: () => setState(() => isLogin = false)) :
      SignUpWidget(onSwitch: () => setState(() => isLogin = true)),
    );
  }
}