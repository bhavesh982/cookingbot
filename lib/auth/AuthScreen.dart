import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/HomePage.dart';
import 'auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _preferencesController = TextEditingController();

  AuthScreen({super.key});

  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
    final authRepo = ref.read(authRepositoryProvider);
    final authStateAsyncValue = ref.watch(authStateProvider);
    final isLogin = ref.read(isLoginProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authStateAsyncValue.whenData((user) {
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      });
    });

    try {
      if (isLogin) {
        await authRepo.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        await authRepo.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          preferences: _parsePreferences(_preferencesController.text),
        );
      }

      // Navigate to HomePage after successful login/signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Map<String, dynamic> _parsePreferences(String input) {
    final prefs = input.split(',').map((e) => e.trim()).toList();
    return {'preferences': prefs};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isLogin = ref.watch(isLoginProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Signup'),
      ),
      body: authState.when(
        data: (user) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLogin)
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                if (!isLogin)
                  TextField(
                    controller: _preferencesController,
                    decoration: const InputDecoration(
                      labelText: 'Preferences (comma-separated)',
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _authenticate(context, ref),
                  child: Text(isLogin ? 'Login' : 'Signup'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(isLoginProvider.notifier).state = !isLogin;
                  },
                  child: Text(
                    isLogin ? 'Create new account' : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
