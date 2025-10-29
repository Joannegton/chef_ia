import 'package:chef_ia/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../providers/favorites_provider.dart';

/// Página de receitas favoritas
class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todas';

  @override
  void initState() {
    super.initState();
    // Carregar favoritos quando a página é inicializada
    Future.microtask(() {
      ref.read(favoritesProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final filteredRecipes = _getFilteredRecipes(favorites);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Receitas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar busca avançada
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar receitas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Todas',
                      'Fácil',
                      'Médio',
                      'Difícil',
                      'Rápido (<30min)',
                      'Lento (>30min)',
                    ].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? filter : 'Todas';
                            });
                          },
                          backgroundColor: Colors.grey.shade100,
                          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Recipes List
          Expanded(
            child: filteredRecipes.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return _buildRecipeCard(recipe, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.favorite_border,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Nenhuma receita encontrada'
                  : 'Nenhuma receita favorita ainda',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tente buscar por outros termos'
                  : 'Gere receitas e adicione às suas favoritas',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Criar Receita',
                onPressed: () => context.goToHome(),
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildRecipeCard(Recipe recipe, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Recipe Header with Image Placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 48,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => _toggleFavorite(recipe),
                      ),
                    ),
                  ),
                  
                  // Recipe Info Overlay
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildInfoBadge(
                              icon: Icons.access_time,
                              label: recipe.tempo,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoBadge(
                              icon: Icons.people,
                              label: '${recipe.porcoes}p',
                            ),
                            const SizedBox(width: 8),
                            _buildInfoBadge(
                              icon: Icons.signal_cellular_alt,
                              label: recipe.dificuldade,
                              color: Color(recipe.difficultyColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Recipe Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.descricao,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.goToRecipeDetail(
                            recipe.id,
                            recipe: recipe.toJson(),
                          ),
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('Ver Receita'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      IconButton(
                        onPressed: () => _shareRecipe(recipe),
                        icon: const Icon(Icons.share),
                        tooltip: 'Compartilhar',
                      ),
                      
                      IconButton(
                        onPressed: () => _deleteRecipe(recipe),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Remover',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
    ).animate(delay: (index * 100).ms).slideY(begin: 0.2).fadeIn();
  }

  Widget _buildInfoBadge({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color != null ? Colors.white : Colors.black87,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color != null ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  List<Recipe> _getFilteredRecipes(List<Recipe> recipes) {
    var filtered = recipes.where((recipe) {
      // Text search
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!recipe.nome.toLowerCase().contains(query) &&
            !recipe.descricao.toLowerCase().contains(query) &&
            !recipe.ingredientes.any((ing) => ing.toLowerCase().contains(query))) {
          return false;
        }
      }
      
      // Filter
      switch (_selectedFilter) {
        case 'Fácil':
          return recipe.dificuldade.toLowerCase() == 'fácil';
        case 'Médio':
          return recipe.dificuldade.toLowerCase() == 'médio';
        case 'Difícil':
          return recipe.dificuldade.toLowerCase() == 'difícil';
        case 'Rápido (<30min)':
          return recipe.tempoMinutos < 30;
        case 'Lento (>30min)':
          return recipe.tempoMinutos >= 30;
        default:
          return true;
      }
    }).toList();
    
    // Sort by creation date (most recent first)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return filtered;
  }

  void _toggleFavorite(Recipe recipe) {
    ref.read(favoritesProvider.notifier).removeFromFavorites(recipe.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Receita removida dos favoritos'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            ref.read(favoritesProvider.notifier).addToFavorites(recipe);
          },
        ),
      ),
    );
  }

  void _shareRecipe(Recipe recipe) {
    // TODO: Implementar compartilhamento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhando "${recipe.nome}"...'),
      ),
    );
  }

  void _deleteRecipe(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Receita'),
        content: Text('Tem certeza que deseja remover "${recipe.nome}" dos favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _toggleFavorite(recipe);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}