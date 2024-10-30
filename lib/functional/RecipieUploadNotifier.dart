import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/RecipieModel.dart';
import '../repository/RecipieRepository.dart';

class RecipeUploadNotifier extends StateNotifier<AsyncValue<void>> {
  final RecipeRepository repository;
  RecipeUploadNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> uploadRecipe(Recipe recipe) async {
    state = const AsyncValue.loading();
    try {
      await repository.addRecipe(recipe);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);  // Add stack trace here
    }
  }
}

final recipeUploadProvider = StateNotifierProvider<RecipeUploadNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(recipeRepositoryProvider);
  return RecipeUploadNotifier(repository);
});
