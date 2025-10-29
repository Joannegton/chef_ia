import 'package:chef_ia/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/config/app_config.dart';
import '../../../../core/providers/auth_provider.dart';

/// Provider para gerenciar ingredientes
final ingredientsProvider = StateNotifierProvider<IngredientsNotifier, List<String>>((ref) {
  return IngredientsNotifier();
});

/// Provider para receitas geradas
final generatedRecipesProvider = StateNotifierProvider<GeneratedRecipesNotifier, List<Recipe>>((ref) {
  return GeneratedRecipesNotifier();
});

/// Provider para verificar se está gerando receitas
final isGeneratingRecipesProvider = StateProvider<bool>((ref) => false);

/// Provider para ingredientes sugeridos
final suggestedIngredientsProvider = Provider<List<String>>((ref) {
  return [
    'Tomate', 'Cebola', 'Alho', 'Arroz', 'Feijão', 'Frango', 'Carne',
    'Batata', 'Cenoura', 'Pimentão', 'Azeite', 'Sal', 'Pimenta',
    'Ovos', 'Leite', 'Queijo', 'Presunto', 'Macarrão', 'Farinha',
    'Açúcar', 'Manteiga', 'Abobrinha', 'Brócolis', 'Couve-flor',
    'Espinafre', 'Rúcula', 'Alface', 'Pepino', 'Limão', 'Manjericão',
  ];
});

/// Notifier para gerenciar ingredientes
class IngredientsNotifier extends StateNotifier<List<String>> {
  IngredientsNotifier() : super([]);

  /// Adiciona um ingrediente
  void addIngredient(String ingredient) {
    if (ingredient.trim().isEmpty) return;
    
    final trimmed = ingredient.trim();
    if (!state.contains(trimmed) && state.length < AppConfig.maxIngredientsCount) {
      state = [...state, trimmed];
    }
  }

  /// Remove um ingrediente
  void removeIngredient(String ingredient) {
    state = state.where((item) => item != ingredient).toList();
  }

  /// Define ingredientes da câmera
  void setIngredientsFromCamera(List<String> ingredients) {
    // Remove duplicatas e limita
    final uniqueIngredients = ingredients
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .take(AppConfig.maxIngredientsCount)
        .toList();
    
    state = uniqueIngredients;
  }

  /// Limpa todos os ingredientes
  void clear() {
    state = [];
  }

  /// Gera receitas usando a API
  Future<List<Recipe>> generateRecipes(WidgetRef ref) async {
    if (state.isEmpty) return [];

    try {
      // Obter o token do Supabase
      final supabase = ref.read(supabaseProvider);
      final token = supabase.auth.currentSession?.accessToken;

      if (token == null) {
        throw Exception('Usuário não autenticado. Por favor, faça login.');
      }

      final response = await http.post(
        Uri.parse('${AppConfig.recipesUrl}/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar token de autenticação
        },
        body: json.encode({
          'ingredients': state,
        }),
      ).timeout(AppConfig.apiTimeout);

      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['recipes'] != null) {
          final recipes = (data['recipes'] as List)
              .map((recipeJson) => Recipe.fromJson(recipeJson as Map<String, dynamic>))
              .toList();

          debugPrint('Receitas geradas com sucesso: ${recipes.length}');
          return recipes;
        } else {
          throw Exception('Resposta da API inválida: ${data['error'] ?? 'Erro desconhecido'}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Falha na autenticação. Por favor, faça login novamente.');
      } else {
        throw Exception('Erro na API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro ao gerar receitas: $e');
      throw Exception('Falha ao gerar receitas: $e');
    }
  }
}

/// Notifier para receitas geradas
class GeneratedRecipesNotifier extends StateNotifier<List<Recipe>> {
  GeneratedRecipesNotifier() : super([]);

  /// Define as receitas geradas
  void setRecipes(List<Recipe> recipes) {
    state = recipes;
  }

  /// Adiciona uma receita
  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
  }

  /// Remove uma receita
  void removeRecipe(String recipeId) {
    state = state.where((recipe) => recipe.id != recipeId).toList();
  }

  /// Limpa as receitas
  void clear() {
    state = [];
  }
}