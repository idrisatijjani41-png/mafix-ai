import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onEditProfile;
  final VoidCallback? onSignOut;

  const ProfileScreen({super.key, this.onEditProfile, this.onSignOut});

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You can sign in again to access your chats.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      if (onSignOut != null) {
        onSignOut!();
      } else {
        await FirebaseAuth.instance.signOut();
      }
      if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not sign out. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6658D3);
    final user = FirebaseAuth.instance.currentUser;
    final name = (user?.displayName ?? '').trim();
    final email = user?.email ?? 'No email available';
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFEAE7FF),
            child: Icon(Icons.person_rounded, size: 46, color: purple),
          ),
          const SizedBox(height: 14),
          Text(
            name.isEmpty ? 'Mafix AI User' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(email, textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 28),
          Card(
            child: Column(children: [
              ListTile(
                leading: const Icon(Icons.verified_user_outlined),
                title: const Text('Account status'),
                subtitle: Text(user == null ? 'Signed out' : 'Signed in'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onEditProfile,
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.workspace_premium_outlined),
                title: Text('Plan'),
                subtitle: Text('Free plan'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.red),
                title: const Text('Sign out', style: TextStyle(color: Colors.red)),
                onTap: user == null ? null : () => _signOut(context),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Text(
            'Your chat history is saved separately for this account on this device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
