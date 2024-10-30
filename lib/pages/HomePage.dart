import 'package:cookbot/functional/CreateRecipiePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/AuthScreen.dart';
import '../auth/auth_provider.dart';
import 'RecipiePage.dart';
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);  // Access auth functions

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authRepo.signOut();
              // Navigate back to AuthScreen on logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Recipe App!'),
            const SizedBox(height: 20),
            const Text('Explore, submit, and manage your favorite recipes here.'),
            ElevatedButton.icon(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RecipeListScreen()));
            }, label: const Icon(Icons.receipt)),
            ElevatedButton.icon(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRecipePage()));
            }, label: const Icon(Icons.add))
          ],
        ),
      ),
    );
  }
}
