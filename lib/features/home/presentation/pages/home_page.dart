import 'package:chef_ia/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../favorites/providers/favorites_provider.dart';
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
    final generatedRecipes = ref.watch(generatedRecipesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              // const PopupMenuItem<String>(
              //   value: 'profile',
              //   child: Text('Perfil'),
              // ),
              // const PopupMenuItem<String>(
              //   value: 'settings',
              //   child: Text('Configurações'),
              // ),
              const PopupMenuItem<String>(
                value: 'delete-account',
                child: Text('Excluir Conta'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                // case 'profile':
                //   // TODO: Implementar perfil
                //   break;
                // case 'settings':
                //   // TODO: Implementar configurações
                //   break;
                case 'delete-account':
                  _showDeleteAccountDialog();
                  break;
                case 'logout':
                  // Limpar estado antes de fazer logout
                  ref.read(ingredientsProvider.notifier).clear();
                  ref.read(generatedRecipesProvider.notifier).clear();
                  ref.read(isGeneratingRecipesProvider.notifier).state = false;
                  
                  // Limpar favoritos também
                  ref.invalidate(favoritesProvider);
                  ref.invalidate(favoritedRecipesProvider);
                  
                  // Fazer logout
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

                    const SizedBox(height: 20),

                    // // Botão da Câmera - Feature principal (comentado para futuro)
                    // Container(
                    //   width: double.infinity,
                    //   height: 220,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //       colors: [
                    //         Theme.of(context).colorScheme.primary,
                    //         Theme.of(context).colorScheme.tertiary,
                    //       ],
                    //     ),
                    //     borderRadius: BorderRadius.circular(24),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    //         blurRadius: 20,
                    //         offset: const Offset(0, 10),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Material(
                    //     color: Colors.transparent,
                    //     child: InkWell(
                    //       borderRadius: BorderRadius.circular(24),
                    //       onTap: () => context.goToCamera(),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(20),
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             AnimatedBuilder(
                    //               animation: _animationController,
                    //               builder: (context, child) {
                    //                 return Transform.scale(
                    //                   scale: 1.0 + (_animationController.value * 0.1),
                    //                   child: Container(
                    //                     width: 70,
                    //                     height: 70,
                    //                     decoration: BoxDecoration(
                    //                       color: Colors.white.withOpacity(0.2),
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: const Icon(
                    //                       Icons.camera_alt,
                    //                       color: Colors.white,
                    //                       size: 35,
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             ),
                    //             const SizedBox(height: 12),
                    //             const Text(
                    //               'Fotografar Geladeira',
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 18,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //             const SizedBox(height: 6),
                    //             Text(
                    //               'Deixe a IA identificar seus ingredientes',
                    //               style: TextStyle(
                    //                 color: Colors.white.withOpacity(0.9),
                    //                 fontSize: 13,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ).animate().scale(delay: 400.ms).shimmer(delay: 1000.ms, duration: 2000.ms),

                    // const SizedBox(height: 32),

                    // Ou separador
                    // Row(
                    //   children: [
                    //     const Expanded(child: Divider()),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 16),
                    //       child: Text(
                    //         'Digite seus ingredientes',
                    //         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    //               color: Colors.grey.shade600,
                    //             ),
                    //       ),
                    //     ),
                    //     const Expanded(child: Divider()),
                    //   ],
                    // ).animate().fadeIn(delay: 600.ms),

                    // const SizedBox(height: 15),

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
                      const SizedBox(height: 15),
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
                      ...generatedRecipes.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildGeneratedRecipeCard(entry.value, entry.key),
                        ).animate(delay: (entry.key * 100).ms).slideY(begin: 0.2).fadeIn(),
                      ),
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
                  child: PrimaryButton(
                    label: 'Gerar Receitas com IA',
                    onPressed: _generateRecipes,
                    icon: Icons.auto_fix_high,
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
      // Mostra o modal de carregamento criativo
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (context) => _buildChefCookingDialog(),
        );
      }

      // Chama a API e obtém as receitas
      final recipes = await ref.read(ingredientsProvider.notifier).generateRecipes(ref);
      
      // Atualiza as receitas geradas
      ref.read(generatedRecipesProvider.notifier).setRecipes(recipes);
      
      if (mounted) {
        Navigator.pop(context); // Fecha o modal de carregamento
        
        // Mostrar anúncio após gerar receitas
        await AdService().showInterstitialAd();
        
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
        Navigator.pop(context); // Fecha o modal de carregamento
        
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

  Widget _buildChefCookingDialog() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Chef animado com fade in
                Text(
                  '👨‍🍳',
                  style: const TextStyle(fontSize: 100),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 32),
                
                // Utensílios girando com fade in cascata
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🔪', style: const TextStyle(fontSize: 48))
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .then()
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(duration: 1500.ms)
                        .then()
                        .rotate(duration: 1500.ms),
                    const SizedBox(width: 24),
                    Text('🍳', style: const TextStyle(fontSize: 48))
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 250.ms)
                        .then()
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(duration: 1000.ms, curve: Curves.easeInOut),
                    const SizedBox(width: 24),
                    Text('🥄', style: const TextStyle(fontSize: 48))
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 300.ms)
                        .then()
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(duration: 1500.ms)
                        .then()
                        .rotate(duration: 1500.ms),
                  ],
                ),
                const SizedBox(height: 48),
                
                // Texto principal com sombra para melhor contraste
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Criando receitas deliciosas...',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 400.ms)
                    .slideY(begin: 0.2, duration: 500.ms, delay: 400.ms),
                const SizedBox(height: 16),
                
                // Mensagem secundária com animação de pontos
                _buildAnimatedLoadingText()
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .slideY(begin: 0.2, duration: 500.ms, delay: 500.ms),
                const SizedBox(height: 32),
                
                // Mensagem de paciência
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⏱️ Isso pode demorar um pouco...',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        height: 1.6,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 600.ms)
                    .slideY(begin: 0.3, duration: 500.ms, delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLoadingText() {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.4),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          int dots = (_animationController.value * 3).floor() % 4;
          return Text(
            'Mexendo a panela${'.' * dots}',
          );
        },
      ),
    );
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
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
                    onPressed: () async {
                      final user = ref.read(currentUserProvider);
                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Faça login para salvar favoritos'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      try {
                        final favoritesNotifier =
                            ref.read(favoritesProvider.notifier);
                        
                        final isFavorite = favoritesNotifier.isFavorite(recipe.id);
                        
                        if (isFavorite) {
                          await favoritesNotifier.removeFromFavorites(recipe.id);
                          ref.read(favoritedRecipesProvider.notifier).setFavorited(recipe.id, false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${recipe.nome} removida dos favoritos'),
                              backgroundColor: Colors.orange,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          // Adicionar aos favoritos
                          await favoritesNotifier.addToFavorites(recipe);
                          ref.read(favoritedRecipesProvider.notifier).setFavorited(recipe.id, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${recipe.nome} salva nos favoritos! ❤️'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Erro ao salvar favorito: ${e.toString()}',
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    icon: ref.watch(favoritedRecipesProvider)[recipe.id] == true
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border),
                    tooltip: 'Salvar nos favoritos',
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  /// Mostra dialog de confirmação para excluir conta
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Conta'),
        content: const Text(
          'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita e todos os seus dados serão perdidos permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Fechar dialog
              await _deleteAccount();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  /// Exclui a conta do usuário
  Future<void> _deleteAccount() async {
    try {
      await ref.read(authServiceProvider).deleteAccount();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta excluída com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir conta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}