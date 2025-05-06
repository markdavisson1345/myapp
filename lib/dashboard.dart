import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final String? email = FirebaseAuth.instance.currentUser?.email;

  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("welcome to the dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcom to the Dashboard!"),
            SizedBox(
              height: 20,
            ),
            Text("Email: $email"),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }, 
              child: Text("Sign Out"))
            ],
          ),
        ),
      );
  }
}
