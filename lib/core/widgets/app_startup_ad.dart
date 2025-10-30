import 'package:chef_ia/core/services/ad_service.dart';
import 'package:flutter/material.dart';

class AppStartupAd extends StatefulWidget {
  final Widget child;

  const AppStartupAd({
    super.key,
    required this.child,
  });

  @override
  State<AppStartupAd> createState() => _AppStartupAdState();
}

class _AppStartupAdState extends State<AppStartupAd> {
  bool _adShown = false;

  @override
  void initState() {
    super.initState();
    _showStartupAd();
  }

  Future<void> _showStartupAd() async {
    final adService = AdService();
    await adService.initialize();
    
    // Aguardar mais tempo para o anúncio carregar completamente
    await Future.delayed(const Duration(seconds: 4));
    
    // Tentar mostrar o anúncio, se não estiver carregado, aguardar mais
    if (mounted && !_adShown) {
      _adShown = true;
    // Tentar mostrar o anúncio, se não estiver carregado, aguardar mais
    if (mounted && !_adShown) {
      _adShown = true;
      
      final success = await adService.showInterstitialAd();
      
      if (!success) {
        await Future.delayed(const Duration(seconds: 3));
        
        if (mounted) {
          final retrySuccess = await adService.showInterstitialAd();
          
          if (!retrySuccess) {
            await Future.delayed(const Duration(seconds: 2));
            
            if (mounted) {
              await adService.showInterstitialAd();
            }
          }
        }
      }
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
