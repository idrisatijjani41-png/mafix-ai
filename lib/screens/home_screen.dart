import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';

/// Routes signed-in users to a fresh chat and signed-out users to Login/Register.
/// Firebase Auth restores the user's session after the app is reopened.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const AuthScreen();
        }
        if (snapshot.data == null) {
          return const AuthScreen();
        }
        // A new ChatScreen is created on every app launch. Previous chats remain
        // available from Chat history instead of reopening the last chat.
        return const ChatScreen(mode: 'Mafix AI');
      },
    );
  }
}
