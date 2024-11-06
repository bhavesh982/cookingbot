import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/RecipieProvider.dart';

class RecipePage extends ConsumerWidget {
  final String recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the specific recipe by ID using the recipeProvider
    final recipeState = ref.watch(recipeProvider(recipeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
      ),
      body: recipeState.when(
        data: (recipe) {
          if (recipe == null) {
            return Center(child: Text('Recipe not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Recipe Image
                Image.network(
                  recipe.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),

                // Display Recipe Title
                Text(
                  recipe.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.cuisine,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Display Recipe Description
                Text(
                  recipe.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),

                // Display Cooking Time
                Text(
                  'Cooking Time: ${recipe.cookingTime} minutes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Display Ingredients
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...recipe.ingredients.map((ingredient) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '${ingredient['name']} - ${ingredient['quantity']} ${ingredient['unit']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),

                // Display Instructions
                const Text(
                  'Instructions:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...recipe.instructions.map((instruction) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      instruction,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
