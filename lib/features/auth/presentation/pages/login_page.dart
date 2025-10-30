import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/widgets/custom_button.dart';

/// Página de login
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _isLoading = false;
  bool _obscurePassword = true;

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
                // Formulário de Login
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.2),

                      const SizedBox(height: 20),

                      // Senha
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _handleLogin();
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
                          return null;
                        },
                      ).animate().fadeIn(delay: 1000.ms).slideX(begin: -0.2),

                      const SizedBox(height: 10),

                      // Esqueci a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _handleForgotPassword,
                          child: const Text('Esqueci minha senha'),
                        ),
                      ).animate().fadeIn(delay: 1100.ms),

                      const SizedBox(height: 12),

                      // Botão de Login
                      PrimaryButton(
                        label: 'Entrar',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ).animate().fadeIn(delay: 1200.ms).scale(begin: const Offset(0.8, 0.8)),

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
                      ).animate().fadeIn(delay: 1300.ms),

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
                      // ).animate().fadeIn(delay: 1400.ms).scale(begin: const Offset(0.8, 0.8)),

                      // const SizedBox(height: 20),

                      // Link para cadastro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não tem conta? ',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () => context.goToRegister(),
                            child: const Text('Criar conta'),
                          ),
                        ],
                      ).animate().fadeIn(delay: 1500.ms),
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

  /// Handles login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔐 Iniciando processo de login...');
      debugPrint('📧 Email: ${_emailController.text.trim()}');
      
      final authService = ref.read(authServiceProvider);
      debugPrint('🔗 Chamando authService.signInWithEmail...');
      
      await authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      debugPrint('✅ Login realizado com sucesso!');
      
      // Mostrar anúncio após login bem-sucedido
      if (mounted) {
        await AdService().showInterstitialAd();
      }
      
      if (mounted) {
        debugPrint('🏠 Navegando para a página inicial...');
        context.goToHome();
      }
    } catch (e) {
      debugPrint('❌ Erro durante o login: $e');
      debugPrint('🔍 Stack trace: ${StackTrace.current}');
      
      if (mounted) {
        _showErrorSnackbar('Erro ao fazer login. Verifique suas credenciais.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('🔄 Estado de loading resetado');
      }
    }
  }

  /// Handles Google Sign In
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🔐 Iniciando login com Google...');
      
      final authService = ref.read(authServiceProvider);
      debugPrint('🔗 Chamando authService.signInWithGoogle...');
      
      final success = await authService.signInWithGoogle();
      
      if (success) {
        debugPrint('✅ Login com Google realizado com sucesso!');
        
        // Mostrar anúncio após login bem-sucedido
        if (mounted) {
          await AdService().showInterstitialAd();
        }
        
        if (mounted) {
          debugPrint('🏠 Navegando para a página inicial...');
          context.goToHome();
        }
      } else {
        debugPrint('⚠️ Login com Google falhou - success = false');
        
        if (mounted) {
          _showErrorSnackbar('Falha ao fazer login com Google');
        }
      }
    } catch (e) {
      debugPrint('❌ Erro durante login com Google: $e');
      debugPrint('🔍 Stack trace: ${StackTrace.current}');
      
      if (mounted) {
        _showErrorSnackbar('Erro ao fazer login com Google. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        debugPrint('🔄 Estado de loading resetado');
      }
    }
  }

  /// Handles forgot password
  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      debugPrint('⚠️ Tentativa de reset de senha sem email preenchido');
      _showErrorSnackbar('Digite seu email primeiro');
      return;
    }

    try {
      debugPrint('🔐 Iniciando reset de senha...');
      debugPrint('📧 Email para reset: ${_emailController.text.trim()}');
      
      final authService = ref.read(authServiceProvider);
      debugPrint('🔗 Chamando authService.resetPassword...');
      
      await authService.resetPassword(_emailController.text.trim());
      
      debugPrint('✅ Email de reset enviado com sucesso!');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de recuperação enviado!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erro durante reset de senha: $e');
      debugPrint('🔍 Stack trace: ${StackTrace.current}');
      
      if (mounted) {
        _showErrorSnackbar('Erro ao enviar email de recuperação. Tente novamente.');
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
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
}