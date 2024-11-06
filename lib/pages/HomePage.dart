import 'package:cookbot/pages/CreateRecipiePage.dart';
import 'package:cookbot/pages/RecipieListPage.dart'; // Assuming this page displays a single recipe
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/AuthScreen.dart';
import '../auth/auth_provider.dart';
import '../providers/RecipieProvider.dart';
import 'RecipiePage.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);  // Access auth functions
    final recipesState = ref.watch(allRecipesProvider);  // Watch all recipes

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feed Section
          Expanded(
            child: recipesState.when(
              data: (recipes) {
                if (recipes.isEmpty) {
                  return Center(child: Text('No recipes available yet.'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75, // Adjust this for item size
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to RecipePage when a recipe is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePage(recipeId: recipe.recipeId),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                recipe.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipe.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            ),
          ),

          // Your existing layout
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome to the Recipe App!'),
                const SizedBox(height: 20),
                const Text('Explore, submit, and manage your favorite recipes here.'),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RecipeListScreen()),
                    );
                  },
                  label: const Icon(Icons.receipt),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateRecipePage()),
                    );
                  },
                  label: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRecipePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
