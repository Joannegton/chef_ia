import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/router/app_router.dart';

/// Página de onboarding com animações
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: 'Bem-vindo ao ChefIA!',
      description: 'Transforme os ingredientes da sua geladeira em receitas incríveis com o poder da Inteligência Artificial.',
      icon: Icons.restaurant_menu,
      color: const Color(0xFF6C63FF),
    ),
    OnboardingStep(
      title: 'Tire uma Foto',
      description: 'Fotografe sua geladeira e deixe nossa IA identificar automaticamente os ingredientes disponíveis.',
      icon: Icons.camera_alt,
      color: const Color(0xFF4ECDC4),
    ),
    OnboardingStep(
      title: 'Receitas Personalizadas',
      description: 'Receba receitas únicas criadas especialmente para os seus ingredientes, com passo a passo detalhado.',
      icon: Icons.auto_fix_high,
      color: const Color(0xFFFF6B6B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Indicador de progresso
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(
                  _steps.length,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(
                        right: index < _steps.length - 1 ? 8 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ).animate().scale(
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
              ),
            ),

            // Conteúdo das páginas
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ícone animado
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: step.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            step.icon,
                            size: 60,
                            color: step.color,
                          ),
                        )
                            .animate()
                            .scale(delay: 200.ms, duration: 600.ms)
                            .shimmer(delay: 800.ms, duration: 1000.ms),

                        const SizedBox(height: 40),

                        // Título
                        Text(
                          step.title,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: step.color,
                              ),
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 20),

                        // Descrição
                        Text(
                          step.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.5,
                                color: Colors.grey.shade600,
                              ),
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Botões de navegação
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Botão Pular
                  if (_currentPage < _steps.length - 1)
                    TextButton(
                      onPressed: () {
                        context.goToLogin();
                      },
                      child: Text(
                        'Pular',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  const Spacer(),

                  // Indicadores de página
                  Row(
                    children: List.generate(
                      _steps.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ).animate().scale(
                        duration: 200.ms,
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Botão Próximo/Começar
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _steps.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.goToLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _steps[_currentPage].color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _currentPage < _steps.length - 1 ? 'Próximo' : 'Começar',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).animate().scale(
                    delay: 800.ms,
                    duration: 300.ms,
                    curve: Curves.easeOut,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

/// Modelo para os passos do onboarding
class OnboardingStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}