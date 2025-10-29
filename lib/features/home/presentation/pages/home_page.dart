import 'package:chef_ia/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/ingredient_chip.dart';
import '../widgets/ingredient_input.dart';
import '../providers/ingredients_provider.dart';

/// Página principal do app
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final ingredients = ref.watch(ingredientsProvider);
    final isGenerating = ref.watch(isGeneratingRecipesProvider);
    final generatedRecipes = ref.watch(generatedRecipesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text('ChefIA'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () => context.goToFavorites(),
          ),
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                user?.userMetadata?['full_name']?.toString().substring(0, 1).toUpperCase() ?? 
                user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Perfil'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Configurações'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  // TODO: Implementar perfil
                  break;
                case 'settings':
                  // TODO: Implementar configurações
                  break;
                case 'logout':
                  await ref.read(authServiceProvider).signOut();
                  break;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saudação
                    Text(
                      'Olá, ${_getFirstName(user?.userMetadata?['full_name']?.toString() ?? user?.email ?? 'Chef')}! 👋',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn().slideX(begin: -0.2),

                    const SizedBox(height: 8),

                    Text(
                      'O que vamos cozinhar hoje?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

                    const SizedBox(height: 32),

                    // Botão da Câmera - Feature principal
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.tertiary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => context.goToCamera(),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1.0 + (_animationController.value * 0.1),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Fotografar Geladeira',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Deixe a IA identificar seus ingredientes',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().scale(delay: 400.ms).shimmer(delay: 1000.ms, duration: 2000.ms),

                    const SizedBox(height: 32),

                    // Ou separador
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'ou digite manualmente',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 24),

                    // Input de ingredientes
                    const IngredientInput()
                        .animate()
                        .fadeIn(delay: 800.ms)
                        .slideY(begin: 0.2),

                    const SizedBox(height: 24),

                    // Lista de ingredientes (chips)
                    if (ingredients.isNotEmpty) ...[
                      Text(
                        'Ingredientes selecionados:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ingredients
                            .asMap()
                            .entries
                            .map(
                              (entry) => IngredientChip(
                                ingredient: entry.value,
                                onRemove: () => ref
                                    .read(ingredientsProvider.notifier)
                                    .removeIngredient(entry.value),
                              ).animate(delay: (entry.key * 100).ms).scale().fadeIn(),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Receitas geradas
                    if (generatedRecipes.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Receitas geradas:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          TextButton.icon(
                            onPressed: () => ref.read(generatedRecipesProvider.notifier).clear(),
                            icon: const Icon(Icons.clear, size: 16),
                            label: const Text('Limpar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...generatedRecipes.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildGeneratedRecipeCard(entry.value, entry.key),
                        ).animate(delay: (entry.key * 100).ms).slideY(begin: 0.2).fadeIn(),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ),

            // Botão gerar receitas
            if (ingredients.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isGenerating ? null : _generateRecipes,
                      icon: isGenerating
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.auto_fix_high),
                      label: Text(
                        isGenerating ? 'Gerando receitas...' : 'Gerar Receitas com IA',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .slideY(begin: 1, duration: 300.ms)
                  .fadeIn(),
          ],
        ),
      ),
    );
  }

  /// Gera receitas com IA
  Future<void> _generateRecipes() async {
    final ingredients = ref.read(ingredientsProvider);
    if (ingredients.isEmpty) return;

    // Define estado de carregamento
    ref.read(isGeneratingRecipesProvider.notifier).state = true;

    try {
      // Chama a API e obtém as receitas
      final recipes = await ref.read(ingredientsProvider.notifier).generateRecipes(ref);
      
      // Atualiza as receitas geradas
      ref.read(generatedRecipesProvider.notifier).setRecipes(recipes);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${recipes.length} receitas geradas com sucesso! 🍽️'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao gerar receitas: $e');
      if (mounted) {
        // Extrair mensagem mais amigável do erro
        String errorMessage = _getErrorMessage(e.toString());
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.orange.shade700,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Tentar novamente',
              textColor: Colors.white,
              onPressed: _generateRecipes,
            ),
          ),
        );
      }
    } finally {
      // Remove estado de carregamento
      ref.read(isGeneratingRecipesProvider.notifier).state = false;
    }
  }

  /// Converte mensagens de erro técnicas em mensagens amigáveis
  String _getErrorMessage(String error) {
    // Mensagens específicas de erro
    if (error.contains('Usuário não autenticado')) {
      return '⚠️ Você não está autenticado. Por favor, faça login novamente.';
    }
    if (error.contains('Limite de requisições')) {
      return '⏱️ Muitas requisições! Por favor, aguarde alguns minutos antes de tentar novamente.';
    }
    if (error.contains('indisponível')) {
      return '🔧 Serviço temporariamente indisponível. Tente novamente em instantes.';
    }
    if (error.contains('conexão')) {
      return '📡 Erro de conexão. Verifique sua internet e tente novamente.';
    }
    if (error.contains('nenhuma receita')) {
      return '😕 Não conseguimos gerar receitas. Tente com ingredientes diferentes.';
    }
    if (error.contains('processar')) {
      return '⚙️ Erro ao processar as receitas. Tente novamente.';
    }
    if (error.contains('401') || error.contains('Unauthorized')) {
      return '🔐 Sessão expirada. Faça login novamente para continuar.';
    }
    
    // Mensagem genérica amigável
    return '😕 Algo deu errado ao gerar as receitas. Verifique sua conexão e tente novamente.';
  }

  /// Extrai o primeiro nome
  String _getFirstName(String fullName) {
    if (fullName.contains('@')) {
      return fullName.split('@').first;
    }
    return fullName.split(' ').first;
  }

  /// Constrói card para receita gerada
  Widget _buildGeneratedRecipeCard(Recipe recipe, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.goToRecipeDetail(
          recipe.id,
          recipe: recipe.toJson(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.nome,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(recipe.difficultyColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      recipe.dificuldade,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(recipe.difficultyColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                recipe.descricao,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    recipe.tempo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.porcoes} porções',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                    onPressed: () {
                      // TODO: Implementar salvar nos favoritos
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${recipe.nome} salva nos favoritos!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.favorite_border),
                    tooltip: 'Salvar nos favoritos',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}