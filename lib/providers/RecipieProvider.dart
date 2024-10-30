// Fetch a specific recipe by ID
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/RecipieModel.dart';
import '../repository/RecipieRepository.dart';

final recipeProvider = FutureProvider.family<Recipe?, String>((ref, recipeId) {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getRecipeById(recipeId);
});

// Stream all recipes
final allRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return repository.getAllRecipes();
});
