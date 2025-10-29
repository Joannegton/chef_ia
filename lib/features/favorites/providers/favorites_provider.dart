import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chef_ia/models/recipe_model.dart';
import 'package:chef_ia/core/config/app_config.dart';
import 'package:chef_ia/core/providers/auth_provider.dart';
import '../services/favorites_service.dart';

/// Provider para o serviço de favoritos
final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return FavoritesService(
    supabase: supabase,
    baseUrl: AppConfig.baseUrl,
  );
});

/// Provider para a lista de favoritos do usuário
final userFavoritesProvider =
    FutureProvider.family<List<Recipe>, String>((ref, userId) async {
  final favoritesService = ref.watch(favoritesServiceProvider);
  try {
    final favoritesData = await favoritesService.getFavorites();
    return favoritesData
        .map((item) => Recipe.fromJson(item['recipe_data'] ?? item))
        .toList();
  } catch (e) {
    throw Exception('Erro ao carregar favoritos: $e');
  }
});

/// Provider para verificar se uma receita está nos favoritos
final isFavoriteProvider =
    FutureProvider.family<bool, String>((ref, recipeId) async {
  final favoritesService = ref.watch(favoritesServiceProvider);
  try {
    return await favoritesService.isFavorite(recipeId);
  } catch (e) {
    return false;
  }
});

/// StateNotifier para gerenciar favoritos localmente
class FavoritesNotifier extends StateNotifier<List<Recipe>> {
  final FavoritesService _favoritesService;

  FavoritesNotifier(this._favoritesService) : super([]);

  /// Carrega os favoritos do servidor
  Future<void> loadFavorites() async {
    try {
      final favoritesData = await _favoritesService.getFavorites();
      final recipes = favoritesData
          .map((item) => Recipe.fromJson(item['recipe_data'] ?? item))
          .toList();
      state = recipes;
    } catch (e) {
      throw Exception('Erro ao carregar favoritos: $e');
    }
  }

  /// Adiciona uma receita aos favoritos
  Future<void> addToFavorites(Recipe recipe) async {
    try {
      await _favoritesService.addToFavorites(
        recipeId: recipe.id,
        recipeData: recipe.toJson(),
      );
      // Adiciona localmente se não estiver já na lista
      if (!state.any((r) => r.id == recipe.id)) {
        state = [...state, recipe];
      }
    } catch (e) {
      throw Exception('Erro ao salvar favorito: $e');
    }
  }

  /// Remove uma receita dos favoritos
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      await _favoritesService.removeFromFavorites(recipeId);
      state = state.where((r) => r.id != recipeId).toList();
    } catch (e) {
      throw Exception('Erro ao remover favorito: $e');
    }
  }

  /// Limpa todos os favoritos locais
  void clear() {
    state = [];
  }

  /// Verifica se uma receita está nos favoritos
  bool isFavorite(String recipeId) {
    return state.any((r) => r.id == recipeId);
  }
}

/// Provider do StateNotifier de favoritos
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Recipe>>((ref) {
  final favoritesService = ref.watch(favoritesServiceProvider);
  return FavoritesNotifier(favoritesService);
});

/// Provider para carregamento assíncrono (com loading state)
final favoritesAsyncProvider = FutureProvider<List<Recipe>>((ref) async {
  final favoritesService = ref.watch(favoritesServiceProvider);
  try {
    final favoritesData = await favoritesService.getFavorites();
    return favoritesData
        .map((item) => Recipe.fromJson(item['recipe_data'] ?? item))
        .toList();
  } catch (e) {
    throw Exception('Erro ao carregar favoritos: $e');
  }
});

/// Provider para verificar e gerenciar estado de favorito individual
class FavoritedRecipe {
  final String recipeId;
  final bool isFavorited;

  FavoritedRecipe({
    required this.recipeId,
    required this.isFavorited,
  });
}

final favoritedRecipesProvider = StateNotifierProvider<
    FavoritedRecipesNotifier,
    Map<String, bool>>((ref) {
  return FavoritedRecipesNotifier();
});

class FavoritedRecipesNotifier extends StateNotifier<Map<String, bool>> {
  FavoritedRecipesNotifier() : super({});

  void setFavorited(String recipeId, bool isFavorited) {
    state = {...state, recipeId: isFavorited};
  }

  bool isFavorited(String recipeId) {
    return state[recipeId] ?? false;
  }
}
