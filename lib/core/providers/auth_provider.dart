import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider para a instância do Supabase
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider para o estado de autenticação
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.read(supabaseProvider);
  return supabase.auth.onAuthStateChange;
});

/// Provider para o usuário atual
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value?.session?.user;
});

/// Provider para verificar se está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// Provider para serviços de autenticação
final authServiceProvider = Provider<AuthService>((ref) {
  final supabase = ref.read(supabaseProvider);
  return AuthService(supabase);
});

/// Provider que escuta mudanças de autenticação e limpa o estado
final authStateListenerProvider = FutureProvider<void>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  // Quando o usuário faz logout (session == null)
  authState.whenData((state) {
    if (state.session == null) {
      // Aqui vamos limpar os dados dos ingredientes e receitas
      // Será feito via invalidate dos providers dependentes
    }
  });
});

/// Serviço de autenticação
class AuthService {
  final SupabaseClient _supabase;
  
  AuthService(this._supabase);
  
  /// Login com email e senha
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Registro com email e senha
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
  }
  
  /// Login com Google (requer configuração)
  Future<bool> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(OAuthProvider.google);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  
  /// Reset de senha
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }
  
  /// Usuário atual
  User? get currentUser => _supabase.auth.currentUser;
  
  /// Stream do estado de autenticação
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}