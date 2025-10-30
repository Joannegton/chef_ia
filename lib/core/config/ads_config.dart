import 'dart:io';

class AdsConfig {
  static const bool useTestAds = false; 
  
  static bool get isEmulator {
    // Verificar se é Android e se contém indicadores de emulador
    if (Platform.isAndroid) {
      // Verificações comuns para emulador Android
      final androidInfo = Platform.operatingSystemVersion.toLowerCase();
      return androidInfo.contains('emulator') || 
             androidInfo.contains('sdk') || 
             androidInfo.contains('generic');
    }
    return false;
  }
  
  /// Determinar se deve usar anúncios de teste baseado na configuração e ambiente
  static bool get shouldUseTestAds {
    if (useTestAds) return true;
    
    if (isEmulator) return true;
    
    return false;
  }
  
  static const String androidAppId = 'ca-app-pub-7575556543606646~7751212134';
  
  /// ID de aplicativo iOS (configurar)
  static const String iosAppId = 'ca-app-pub-7575556543606646~7751212134';
  
  // ============ BANNER ADS ============
  /// ID de teste para banner Android
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  
  /// ID de teste para banner iOS
  static const String bannerAdUnitIdIos = 'ca-app-pub-3940256099942544/2934735716';
  
  // ============ INTERSTITIAL ADS ============
  /// ID do bloco de anúncios intersticiais (seu ID real)
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-7575556543606646/6469920056';
  
  /// ID do bloco de anúncios intersticiais iOS (configure quando tiver)
  static const String interstitialAdUnitIdIos = 'ca-app-pub-7575556543606646/6469920056';
  
  // ============ IDs de TESTE (fallback) ============
  static const String testAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String testAppIdIos = 'ca-app-pub-3940256099942544~1458002511';
  static const String testInterstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialAdUnitIdIos = 'ca-app-pub-3940256099942544/4411468910';

  /// Obter ID do app para a plataforma atual
  static String get appId {
    if (Platform.isAndroid) {
      return shouldUseTestAds ? testAppIdAndroid : androidAppId;
    } else if (Platform.isIOS) {
      return shouldUseTestAds ? testAppIdIos : iosAppId;
    }
    throw UnsupportedError('Plataforma não suportada');
  }
}
