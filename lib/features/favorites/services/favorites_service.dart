import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesService {
  final SupabaseClient supabase;
  final String baseUrl;

  FavoritesService({
    required this.supabase,
    required this.baseUrl,
  });

  /// Obtém o token de autenticação do usuário
  Future<String?> _getAuthToken() async {
    final session = supabase.auth.currentSession;
    return session?.accessToken;
  }

  /// Headers padrão para requisições
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('Usuário não autenticado');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Adiciona uma receita aos favoritos
  Future<void> addToFavorites({
    required String recipeId,
    required Map<String, dynamic> recipeData,
  }) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/recipes/favorites');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'recipeId': recipeId,
          'recipeData': recipeData,
        }),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(
          'Erro ao salvar favorito: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro em addToFavorites: $e');
      rethrow;
    }
  }

  /// Remove uma receita dos favoritos
  Future<void> removeFromFavorites(String recipeId) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/recipes/favorites/$recipeId');

      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Erro ao remover favorito: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro em removeFromFavorites: $e');
      rethrow;
    }
  }

  /// Obtém todos os favoritos do usuário
  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/recipes/favorites');

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Erro ao buscar favoritos: ${response.statusCode} - ${response.body}',
        );
      }

      final data = jsonDecode(response.body);
      final favorites = (data['favorites'] as List?)
              ?.map((item) => Map<String, dynamic>.from(item as Map))
              .toList() ??
          [];

      return favorites;
    } catch (e) {
      debugPrint('Erro em getFavorites: $e');
      rethrow;
    }
  }

  /// Verifica se uma receita está nos favoritos
  Future<bool> isFavorite(String recipeId) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/recipes/favorites/check/$recipeId');

      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }

      return false;
    } catch (e) {
      debugPrint('Erro em isFavorite: $e');
      return false;
    }
  }
}
