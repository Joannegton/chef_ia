import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/recipe/presentation/pages/recipe_detail_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../providers/auth_provider.dart';

/// Provider do router da aplicação
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final isAuthenticated = authState.value?.session != null;
      final location = state.matchedLocation;
      
      // Se não está autenticado e não está na tela de login/onboarding
      if (!isAuthenticated && 
          !location.startsWith('/login') && 
          !location.startsWith('/onboarding')) {
        return '/onboarding';
      }
      
      // Se está autenticado e está na tela de login/onboarding
      if (isAuthenticated && 
          (location.startsWith('/login') || location.startsWith('/onboarding'))) {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      
      // Auth
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          // Camera
          GoRoute(
            path: 'camera',
            name: 'camera',
            builder: (context, state) => const CameraPage(),
          ),
          
          // Recipe Detail
          GoRoute(
            path: 'recipe/:id',
            name: 'recipe-detail',
            builder: (context, state) {
              final recipeId = state.pathParameters['id']!;
              final recipe = state.extra as Map<String, dynamic>?;
              return RecipeDetailPage(
                recipeId: recipeId,
                recipe: recipe,
              );
            },
          ),
          
          // Favorites
          GoRoute(
            path: 'favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesPage(),
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Erro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página não encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? 'Caminho: ${state.matchedLocation}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Extensões para navegação
extension AppNavigation on BuildContext {
  // Auth
  void goToOnboarding() => go('/onboarding');
  void goToLogin() => go('/login');
  
  // Main
  void goToHome() => go('/home');
  void goToCamera() => go('/home/camera');
  void goToFavorites() => go('/home/favorites');
  
  // Recipe
  void goToRecipeDetail(String recipeId, {Map<String, dynamic>? recipe}) {
    go('/home/recipe/$recipeId', extra: recipe);
  }
  
  // Navigation with results
  Future<T?> pushCamera<T>() => push<T>('/home/camera');
  Future<T?> pushRecipeDetail<T>(String recipeId, {Map<String, dynamic>? recipe}) {
    return push<T>('/home/recipe/$recipeId', extra: recipe);
  }
}