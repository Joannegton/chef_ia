import 'package:uuid/uuid.dart';

/// Modelo para uma receita
class Recipe {
  final String id;
  final String nome;
  final String descricao;
  final String tempo;
  final String dificuldade;
  final int porcoes;
  final List<String> ingredientes;
  final List<String> preparo;
  final String dica;
  final DateTime createdAt;
  final bool isFavorite;

  Recipe({
    String? id,
    required this.nome,
    required this.descricao,
    required this.tempo,
    required this.dificuldade,
    required this.porcoes,
    required this.ingredientes,
    required this.preparo,
    required this.dica,
    DateTime? createdAt,
    this.isFavorite = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Cria uma receita a partir de JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String?,
      nome: json['nome'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      tempo: json['tempo'] as String? ?? '',
      dificuldade: json['dificuldade'] as String? ?? '',
      porcoes: json['porcoes'] as int? ?? 1,
      ingredientes: (json['ingredientes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preparo: (json['preparo'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      dica: json['dica'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  /// Converte a receita para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tempo': tempo,
      'dificuldade': dificuldade,
      'porcoes': porcoes,
      'ingredientes': ingredientes,
      'preparo': preparo,
      'dica': dica,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }

  /// Cria uma cópia da receita com novos valores
  Recipe copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? tempo,
    String? dificuldade,
    int? porcoes,
    List<String>? ingredientes,
    List<String>? preparo,
    String? dica,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      tempo: tempo ?? this.tempo,
      dificuldade: dificuldade ?? this.dificuldade,
      porcoes: porcoes ?? this.porcoes,
      ingredientes: ingredientes ?? this.ingredientes,
      preparo: preparo ?? this.preparo,
      dica: dica ?? this.dica,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Calcula o tempo total estimado em minutos
  int get tempoMinutos {
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(tempo);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '0') ?? 0;
    }
    return 0;
  }

  /// Retorna a cor baseada na dificuldade
  int get difficultyColor {
    switch (dificuldade.toLowerCase()) {
      case 'fácil':
        return 0xFF4CAF50; // Verde
      case 'médio':
      case 'medio':
        return 0xFFFF9800; // Laranja
      case 'difícil':
      case 'dificil':
        return 0xFFF44336; // Vermelho
      default:
        return 0xFF2196F3; // Azul
    }
  }

  @override
  String toString() {
    return 'Recipe(id: $id, nome: $nome, tempo: $tempo, dificuldade: $dificuldade)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Modelo para ingrediente detectado por ML
class DetectedIngredient {
  final String name;
  final double confidence;
  final Map<String, double> boundingBox;

  DetectedIngredient({
    required this.name,
    required this.confidence,
    required this.boundingBox,
  });

  factory DetectedIngredient.fromJson(Map<String, dynamic> json) {
    return DetectedIngredient(
      name: json['name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      boundingBox: Map<String, double>.from(json['bounding_box'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'confidence': confidence,
      'bounding_box': boundingBox,
    };
  }
}

/// Modelo para resposta da API de receitas
class RecipeGenerationResponse {
  final List<Recipe> recipes;
  final bool success;
  final String? error;
  final Map<String, dynamic>? metadata;

  RecipeGenerationResponse({
    required this.recipes,
    this.success = true,
    this.error,
    this.metadata,
  });

  factory RecipeGenerationResponse.fromJson(Map<String, dynamic> json) {
    return RecipeGenerationResponse(
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((e) => Recipe.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      success: json['success'] as bool? ?? true,
      error: json['error'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipes': recipes.map((e) => e.toJson()).toList(),
      'success': success,
      'error': error,
      'metadata': metadata,
    };
  }
}