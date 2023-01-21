import 'package:conu_hacks_2005/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final authService = AuthService.instance;
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orderwise'),
      ),
      body: StreamBuilder<User?>(
          stream: authService.currentUser,
          builder: (context, snapshot) {
            final user = snapshot.data;
            if (!snapshot.hasData) {
              return Center(
                  child: MaterialButton(
                      child: const Text('Google sign in'),
                      onPressed: () {
                        authService.handleSignIn();
                      }));
            }
            return Center(
              child: Text("${user?.displayName ?? ''}is logged in"),
            );
          }),
    );
  }
}
