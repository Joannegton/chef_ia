import 'package:flutter/foundation.dart';

/// Configurações globais do app
class AppConfig {
  static const String appName = 'ChefIA';
  static const String appVersion = '1.0.0';
  
  // URLs da API - configuração inteligente para diferentes ambientes
  // Para desenvolvimento local:
  // - Flutter Web: http://localhost:3000/api/v1
  // - Android Emulator: http://10.0.2.2:3000/api/v1 ou IP da máquina
  // - iOS Simulator: http://127.0.0.1:3000/api/v1 ou IP da máquina
  // - Dispositivo físico: IP da máquina (ex: http://192.168.1.4:3000/api/v1)
  static String get baseUrl {
    if (!kDebugMode) {
      return 'https://chefia-api-production.up.railway.app/api/v1';
    }
    
    // Em modo debug, detectar automaticamente o ambiente
    if (kIsWeb) {
      // Web: usar localhost diretamente
      return 'http://192.168.1.4:3000/api/v1';
    } else {
      // Mobile: tentar diferentes IPs para emuladores/dispositivos
      // Para Android Emulator, iOS Simulator ou dispositivo físico
      // IMPORTANTE: Altere este IP para o IP da sua máquina local
      return 'http://192.168.1.4:3000/api/v1';
    }
  }
  
  /// Exemplo: flutter build appbundle --dart-define=SUPABASE_URL=https://seu-projeto.supabase.co
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xmslymknvycpazjupthf.supabase.co',
  );

  /// Exemplo: flutter build appbundle --dart-define=SUPABASE_ANON_KEY=sua-chave-aqui
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhtc2x5bWtudnljcGF6anVwdGhmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2ODAxNzUsImV4cCI6MjA3NzI1NjE3NX0.7qyCrboETED-vp-XIlrZ2hCbeY-ofuftHw0k412WRoM',
  );

  // Debug
  static const bool isDebug = kDebugMode;
  
  // Rate limiting
  static const Duration aiRequestCooldown = Duration(minutes: 1);
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  // static const Duration cameraTimeout = Duration(seconds: 10);
  
  // Limits
  static const int maxIngredientsCount = 20;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  
  // Cache
  static const Duration cacheExpiry = Duration(hours: 1);
  
  // Analytics
  static const bool enableAnalytics = !kDebugMode;
  
  // Endpoints
  static String get authUrl => '$baseUrl/auth';
  static String get recipesUrl => '$baseUrl/recipes';
  static String get favoritesUrl => '$baseUrl/recipes/favorites';
  
  /// Valida se as configurações estão corretas
  static bool get isConfigured {
    return supabaseUrl != 'https://SEU_PROJECT.supabase.co' &&
           supabaseAnonKey != 'SEU_ANON_KEY_AQUI';
  }
}