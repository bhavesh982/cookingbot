import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/RecipieModel.dart';
import 'RecipieUploadNotifier.dart';


class CreateRecipePage extends ConsumerStatefulWidget {
  const CreateRecipePage({super.key});

  @override
  _CreateRecipePageState createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends ConsumerState<CreateRecipePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cuisineController = TextEditingController();
  final TextEditingController _mealTypeController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();

  List<Map<String, String>> _ingredients = [];
  List<String> _instructions = [];
  File? _imageFile;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    final storageRef = FirebaseStorage.instance.ref().child('recipes/${DateTime.now().toString()}');
    final uploadTask = storageRef.putFile(_imageFile!);
    final snapshot = await uploadTask.whenComplete(() {});
    _imageUrl = await snapshot.ref.getDownloadURL();
  }

  Future<void> _submitRecipe() async {
    await _uploadImage();
    if (_imageUrl == null) return; // Handle image not uploaded

    final newRecipe = Recipe(
      recipeId: '',
      title: _titleController.text,
      description: _descriptionController.text,
      cuisine: _cuisineController.text,
      mealType: _mealTypeController.text,
      ingredients: _ingredients,
      instructions: _instructions,
      cookingTime: int.tryParse(_cookingTimeController.text) ?? 0,
      imageUrl: _imageUrl!,
      createdBy: 'userId',  // Replace with actual user ID
      createdAt: Timestamp.now(),
    );

    await ref.read(recipeUploadProvider.notifier).uploadRecipe(newRecipe);
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({'name': '', 'quantity': '', 'unit': ''});
    });
  }

  void _addInstruction() {
    setState(() {
      _instructions.add('');
    });
  }

  Widget _buildIngredientFields(int index) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => _ingredients[index]['name'] = value,
            decoration: InputDecoration(labelText: 'Name'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            onChanged: (value) => _ingredients[index]['quantity'] = value,
            decoration: InputDecoration(labelText: 'Quantity'),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            onChanged: (value) => _ingredients[index]['unit'] = value,
            decoration: InputDecoration(labelText: 'Unit'),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionFields(int index) {
    return TextField(
      onChanged: (value) => _instructions[index] = value,
      decoration: InputDecoration(labelText: 'Instruction ${index + 1}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(recipeUploadProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Create Recipe')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (uploadState.isLoading) Center(child: CircularProgressIndicator()),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _cuisineController,
              decoration: InputDecoration(labelText: 'Cuisine'),
            ),
            TextField(
              controller: _mealTypeController,
              decoration: InputDecoration(labelText: 'Meal Type'),
            ),
            TextField(
              controller: _cookingTimeController,
              decoration: InputDecoration(labelText: 'Cooking Time (in minutes)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._ingredients.asMap().entries.map((entry) {
              int index = entry.key;
              return _buildIngredientFields(index);
            }),
            ElevatedButton(
              onPressed: _addIngredient,
              child: Text('Add Ingredient'),
            ),
            SizedBox(height: 16),
            Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._instructions.asMap().entries.map((entry) {
              int index = entry.key;
              return _buildInstructionFields(index);
            }),
            ElevatedButton(
              onPressed: _addInstruction,
              child: Text('Add Instruction'),
            ),
            SizedBox(height: 16),
            _imageFile != null
                ? Image.file(_imageFile!)
                : TextButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadState.isLoading ? null : _submitRecipe,
              child: Text('Submit Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
