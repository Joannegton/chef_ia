import 'package:chef_ia/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

/// Página de detalhes da receita
class RecipeDetailPage extends ConsumerStatefulWidget {
  final String recipeId;
  final Map<String, dynamic>? recipe;

  const RecipeDetailPage({
    super.key,
    required this.recipeId,
    this.recipe,
  });

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<bool> _checkedSteps = [];
  Timer? _timer;
  int _currentTime = 0;
  bool _isTimerRunning = false;
  int _currentStep = 0;

  Recipe? _currentRecipe;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRecipe();
  }

  void _loadRecipe() {
    if (widget.recipe != null) {
      _currentRecipe = Recipe.fromJson(widget.recipe!);
      _initializeSteps();
    }
    // TODO: Carregar receita por ID se não fornecida
  }

  void _initializeSteps() {
    if (_currentRecipe != null) {
      _checkedSteps.clear();
      _checkedSteps.addAll(List.filled(_currentRecipe!.preparo.length, false));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentRecipe == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Receita')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _currentRecipe!.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
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
                      // Pattern background
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 120,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                      ),
                      
                      // Recipe info overlay
                      Positioned(
                        bottom: 80,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildInfoChip(
                                  icon: Icons.access_time,
                                  label: _currentRecipe!.tempo,
                                ),
                                const SizedBox(width: 8),
                                _buildInfoChip(
                                  icon: Icons.people,
                                  label: '${_currentRecipe!.porcoes} porções',
                                ),
                                const SizedBox(width: 8),
                                _buildInfoChip(
                                  icon: Icons.signal_cellular_alt,
                                  label: _currentRecipe!.dificuldade,
                                  color: Color(_currentRecipe!.difficultyColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _currentRecipe!.isFavorite 
                        ? Icons.favorite 
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: _toggleFavorite,
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 8),
                          Text('Compartilhar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'save',
                      child: Row(
                        children: [
                          Icon(Icons.download),
                          SizedBox(width: 8),
                          Text('Salvar'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    // TODO: Implementar ações
                  },
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Tab Bar
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Ingredientes'),
                  Tab(text: 'Preparo'),
                  Tab(text: 'Dicas'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIngredientsTab(),
                  _buildPreparationTab(),
                  _buildTipsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Timer FAB
      floatingActionButton: _buildTimerFAB(),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.white).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color != null ? Colors.white : Colors.black87,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color != null ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentRecipe!.ingredientes.length,
      itemBuilder: (context, index) {
        final ingredient = _currentRecipe!.ingredientes[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.restaurant,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              ingredient,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                // TODO: Adicionar à lista de compras
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$ingredient adicionado à lista de compras'),
                  ),
                );
              },
            ),
          ),
        ).animate(delay: (index * 100).ms).slideX().fadeIn();
      },
    );
  }

  Widget _buildPreparationTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _currentRecipe!.preparo.length,
      itemBuilder: (context, index) {
        final step = _currentRecipe!.preparo[index];
        final isChecked = index < _checkedSteps.length ? _checkedSteps[index] : false;
        final isCurrentStep = index == _currentStep;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isCurrentStep ? 4 : 1,
          color: isCurrentStep 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step number / checkbox
                GestureDetector(
                  onTap: () => _toggleStep(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isChecked 
                          ? Colors.green 
                          : isCurrentStep
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isChecked ? Icons.check : Icons.play_arrow,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Step content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passo ${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        step,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.4,
                          decoration: isChecked 
                              ? TextDecoration.lineThrough 
                              : null,
                          color: isChecked 
                              ? Colors.grey 
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Timer button for current step
                if (isCurrentStep)
                  IconButton(
                    icon: Icon(
                      _isTimerRunning ? Icons.pause : Icons.timer,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _toggleTimer,
                  ),
              ],
            ),
          ),
        ).animate(delay: (index * 100).ms).slideY(begin: 0.2).fadeIn();
      },
    );
  }

  Widget _buildTipsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Descrição',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentRecipe!.descricao,
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.2),
          
          const SizedBox(height: 16),
          
          // Tips
          if (_currentRecipe!.dica.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dica do Chef',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _currentRecipe!.dica,
                        style: const TextStyle(
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildTimerFAB() {
    if (!_isTimerRunning && _currentTime == 0) return const SizedBox.shrink();
    
    return FloatingActionButton.extended(
      onPressed: _toggleTimer,
      icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
      label: Text(_formatTime(_currentTime)),
      backgroundColor: _isTimerRunning 
          ? Theme.of(context).colorScheme.secondary
          : Colors.grey,
    );
  }

  void _toggleStep(int index) {
    setState(() {
      _checkedSteps[index] = !_checkedSteps[index];
      if (_checkedSteps[index] && index == _currentStep) {
        // Move to next unchecked step
        for (int i = _currentStep + 1; i < _checkedSteps.length; i++) {
          if (!_checkedSteps[i]) {
            _currentStep = i;
            break;
          }
        }
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
    
    if (_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _currentTime++;
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  void _toggleFavorite() {
    // TODO: Implementar toggle de favorito
    setState(() {
      _currentRecipe = _currentRecipe!.copyWith(
        isFavorite: !_currentRecipe!.isFavorite,
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _currentRecipe!.isFavorite 
              ? 'Receita adicionada aos favoritos' 
              : 'Receita removida dos favoritos',
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}