import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

/// Página de cadastro
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo/Título
                Column(
                  children: [
                    // Logo com imagem + fallback para ícone
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback automático para ícone se imagem falhar
                            debugPrint('Erro ao carregar logo: $error');
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.restaurant_menu,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ).animate().scale(duration: 600.ms),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      'ChefIA',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'Suas receitas com IA',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),

                const SizedBox(height: 20),
                // Formulário de Cadastro
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nome
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _emailFocus.requestFocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Nome completo',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite seu nome';
                          }
                          if (value.length < 2) {
                            return 'Nome deve ter pelo menos 2 caracteres';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),

                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _passwordFocus.requestFocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite seu email';
                          }
                          if (!value.contains('@')) {
                            return 'Digite um email válido';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2),

                      const SizedBox(height: 20),

                      // Senha
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _confirmPasswordFocus.requestFocus();
                        },
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite sua senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.2),

                      const SizedBox(height: 20),

                      // Confirmar Senha
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _handleRegister();
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirmar senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme sua senha';
                          }
                          if (value != _passwordController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.2),

                      const SizedBox(height: 32),

                      // Botão de Cadastro
                      PrimaryButton(
                        label: 'Criar conta',
                        onPressed: _handleRegister,
                        isLoading: _isLoading,
                      ).animate().fadeIn(delay: 1000.ms).scale(begin: const Offset(0.8, 0.8)),

                      const SizedBox(height: 24),

                      // Ou divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'ou',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ).animate().fadeIn(delay: 1100.ms),

                      const SizedBox(height: 24),

                      // // Google Sign In - Design moderno e profissional
                      // Container(
                      //   width: double.infinity,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: Colors.grey.shade300,
                      //       width: 1,
                      //     ),
                      //     borderRadius: BorderRadius.circular(12),
                      //     color: Colors.white,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withOpacity(0.05),
                      //         blurRadius: 4,
                      //         offset: const Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Material(
                      //     color: Colors.transparent,
                      //     borderRadius: BorderRadius.circular(12),
                      //     child: InkWell(
                      //       borderRadius: BorderRadius.circular(12),
                      //       onTap: _isLoading ? null : _handleGoogleSignIn,
                      //       splashColor: Colors.grey.shade100,
                      //       highlightColor: Colors.grey.shade50,
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 16),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             // Logo do Google (com tentativa de imagem oficial)
                      //             SizedBox(
                      //               width: 24,
                      //               height: 24,
                      //               child: Image.network(
                      //                 'https://developers.google.com/identity/images/g-logo.png',
                      //                 width: 24,
                      //                 height: 24,
                      //                 fit: BoxFit.contain,
                      //                 errorBuilder: (context, error, stackTrace) {
                      //                   // Fallback para representação visual se imagem falhar
                      //                   return Container(
                      //                     width: 24,
                      //                     height: 24,
                      //                     decoration: BoxDecoration(
                      //                       color: Colors.white,
                      //                       borderRadius: BorderRadius.circular(3),
                      //                       border: Border.all(
                      //                         color: Colors.grey.shade300,
                      //                         width: 0.5,
                      //                       ),
                      //                     ),
                      //                     child: Stack(
                      //                       alignment: Alignment.center,
                      //                       children: [
                      //                         // Fundo azul
                      //                         Container(
                      //                           width: 18,
                      //                           height: 18,
                      //                           decoration: BoxDecoration(
                      //                             color: const Color(0xFF4285F4),
                      //                             borderRadius: BorderRadius.circular(2),
                      //                           ),
                      //                         ),
                      //                         // Letra G branca
                      //                         const Text(
                      //                           'G',
                      //                           style: TextStyle(
                      //                             color: Colors.white,
                      //                             fontSize: 14,
                      //                             fontWeight: FontWeight.w600,
                      //                             fontFamily: 'Roboto',
                      //                             height: 1.0,
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //             const SizedBox(width: 12),
                      //             Text(
                      //               'Continuar com Google',
                      //               style: TextStyle(
                      //                 color: Colors.grey.shade700,
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.w500,
                      //                 letterSpacing: 0.1,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ).animate().fadeIn(delay: 1200.ms).scale(begin: const Offset(0.8, 0.8)),

                      // const SizedBox(height: 20),

                      // Link para login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já tem conta? ',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () => context.goToLogin(),
                            child: const Text('Fazer login'),
                          ),
                        ],
                      ).animate().fadeIn(delay: 1300.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles register
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signUpWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
      );

      if (mounted) {
        context.goToHome();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erro ao criar conta. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handles Google Sign In
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.signInWithGoogle();

      if (success && mounted) {
        context.goToHome();
      } else if (mounted) {
        _showErrorSnackbar('Falha ao fazer login com Google');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Erro ao fazer login com Google. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Shows error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }
}