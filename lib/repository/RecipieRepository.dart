import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookbot/models/RecipieModel.dart';

import '../auth/auth_provider.dart';

class RecipeRepository {
  final FirebaseFirestore firestore;

  RecipeRepository(this.firestore);

  // Fetch a specific recipe by ID
  Future<Recipe?> getRecipeById(String recipeId) async {
    final doc = await firestore.collection('recipes').doc(recipeId).get();
    if (doc.exists) {
      return Recipe.fromFirestore(doc);
    }
    return null;
  }

  // Fetch all recipes
  Stream<List<Recipe>> getAllRecipes() {
    return firestore.collection('recipes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
    });
  }

  // Add a new recipe
  Future<void> addRecipe(Recipe recipe) async {
    await firestore.collection('recipes').add(recipe.toFirestore());
  }

  // Update an existing recipe
  Future<void> updateRecipe(String recipeId, Map<String, dynamic> data) async {
    await firestore.collection('recipes').doc(recipeId).update(data);
  }

  // Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    await firestore.collection('recipes').doc(recipeId).delete();
  }
}

// Provider for RecipeRepository
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return RecipeRepository(firestore);
});
