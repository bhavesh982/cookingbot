import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String recipeId;
  final String title;
  final String description;
  final String cuisine;
  final String mealType;
  final List<Map<String, dynamic>> ingredients;
  final List<String> instructions;
  final int cookingTime;
  final String imageUrl;
  final int likes;
  final Map<String, double> ratings;
  final String createdBy;
  final Timestamp createdAt;

  Recipe({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.cuisine,
    required this.mealType,
    required this.ingredients,
    required this.instructions,
    required this.cookingTime,
    required this.imageUrl,
    this.likes = 0,
    this.ratings = const {},
    required this.createdBy,
    required this.createdAt,
  });

  // Factory method to create a Recipe instance from Firestore data
  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      recipeId: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      cuisine: data['cuisine'] as String,
      mealType: data['mealType'] as String,
      ingredients: List<Map<String, dynamic>>.from(data['ingredients']),
      instructions: List<String>.from(data['instructions']),
      cookingTime: data['cookingTime'] as int,
      imageUrl: data['imageUrl'] as String,
      likes: data['likes'] ?? 0,
      ratings: Map<String, double>.from(data['ratings'] ?? {}),
      createdBy: data['createdBy'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  // Convert Recipe instance to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'cuisine': cuisine,
      'mealType': mealType,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookingTime': cookingTime,
      'imageUrl': imageUrl,
      'likes': likes,
      'ratings': ratings,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
