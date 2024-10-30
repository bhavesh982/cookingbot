import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';

class AuthScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AuthScreen({super.key});
  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
    final authRepo = ref.read(authRepositoryProvider);
    final isLogin = ref.read(isLoginProvider);  // Read the current isLogin state
    try {
      if (isLogin) {
        await authRepo.signIn(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await authRepo.signUp(
          _emailController.text,
          _passwordController.text,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isLogin ? 'Login Successful' : 'Signup Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isLogin = ref.watch(isLoginProvider);  // Watch the isLogin state

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Signup'),
      ),
      body: authState.when(
        data: (user) {
          if (user != null) {
            return Center(child: Text('Logged in as: ${user.email}'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _authenticate(context, ref),
                  child: Text(isLogin ? 'Login' : 'Signup'),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(isLoginProvider.notifier).state = !isLogin;
                  },
                  child: Text(isLogin ? 'Create new account' : 'Already have an account? Login'),
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
