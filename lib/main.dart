import 'package:chef_ia/core/config/app_config.dart';
import 'package:chef_ia/core/router/app_router.dart';
import 'package:chef_ia/core/services/ad_service.dart';
import 'package:chef_ia/core/theme/app_theme.dart';
import 'package:chef_ia/core/widgets/app_startup_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  
    // Inicializar Supabase
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      debug: AppConfig.isDebug,
    );

    // Inicializar anúncios
    await AdService().initialize();
    
    runApp(
      const ProviderScope(
        child: ChefIAApp(),
      ),
    );
}

class ChefIAApp extends ConsumerWidget {
  const ChefIAApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'ChefIA',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      
      // Router
      routerConfig: router,
      
      // Configurações globais
      builder: (context, child) {
        return AppStartupAd(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling, // Previne mudanças de escala
            ),
            child: child!,
          ),
        );
      },
    );
  }
}
