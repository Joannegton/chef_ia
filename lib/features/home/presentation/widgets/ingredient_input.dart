import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ingredients_provider.dart';

/// Widget para input de ingredientes com autocomplete
class IngredientInput extends ConsumerStatefulWidget {
  const IngredientInput({super.key});

  @override
  ConsumerState<IngredientInput> createState() => _IngredientInputState();
}

class _IngredientInputState extends ConsumerState<IngredientInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final suggestedIngredients = ref.watch(suggestedIngredientsProvider);
    final currentIngredients = ref.watch(ingredientsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo de texto
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            labelText: 'Adicionar ingrediente',
            hintText: 'Ex: tomate, cebola, frango...',
            prefixIcon: const Icon(Icons.add),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addIngredient,
                  )
                : null,
          ),
          onFieldSubmitted: (_) => _addIngredient(),
          onChanged: (value) {
            setState(() {}); // Para atualizar o suffixIcon
          },
        ),

        // Sugestões
        if (_focusNode.hasFocus) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _getFilteredSuggestions(suggestedIngredients, currentIngredients).length,
              itemBuilder: (context, index) {
                final suggestions = _getFilteredSuggestions(suggestedIngredients, currentIngredients);
                final ingredient = suggestions[index];
                
                return ListTile(
                  dense: true,
                  title: Text(ingredient),
                  leading: const Icon(Icons.add_circle_outline),
                  onTap: () {
                    ref.read(ingredientsProvider.notifier).addIngredient(ingredient);
                    _controller.clear();
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  /// Adiciona ingrediente da entrada de texto
  void _addIngredient() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      ref.read(ingredientsProvider.notifier).addIngredient(text);
      _controller.clear();
    }
  }

  /// Filtra sugestões baseado no texto digitado e ingredientes já selecionados
  List<String> _getFilteredSuggestions(List<String> suggestions, List<String> currentIngredients) {
    final query = _controller.text.toLowerCase();
    
    return suggestions
        .where((ingredient) => 
            ingredient.toLowerCase().contains(query) &&
            !currentIngredients.contains(ingredient))
        .take(5)
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}