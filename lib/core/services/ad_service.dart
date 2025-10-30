import 'dart:io';
import 'package:chef_ia/core/config/ads_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Serviço para gerenciar todos os anúncios do app
/// Baseado na documentação oficial do Google Mobile Ads
class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() {
    return _instance;
  }

  AdService._internal();

  bool _isInitialized = false;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  // Configurações baseadas na documentação
  static const int maxFailedLoadAttempts = 3;

  static final AdRequest request = AdRequest(
    keywords: <String>['cozinha', 'receitas', 'comida', 'culinária'],
    contentUrl: 'https://chefia.app',
    nonPersonalizedAds: true,
  );

  /// Inicializa o Google Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      // Pré-carregar interstitial para uso futuro
      _createInterstitialAd();
    } catch (e) {
      // Silenciar erro de inicialização para produção
    }
  }

  // ============ BANNER ADS ============

  /// Obter ID do banner de anúncio para a plataforma atual
  String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return AdsConfig.bannerAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return AdsConfig.bannerAdUnitIdIos;
    }
    throw UnsupportedError('Plataforma não suportada');
  }

  /// Criar e carregar um banner ad
  Future<BannerAd?> createBannerAd() async {
    if (!_isInitialized) {
      await initialize();
    }

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: request,
      listener: BannerAdListener(
        onAdLoaded: (ad) => {},
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    await _bannerAd?.load();
    return _bannerAd;
  }

  /// Obter banner ad carregado
  BannerAd? get bannerAd => _bannerAd;

  /// Descarregar banner ad
  Future<void> disposeBannerAd() async {
    await _bannerAd?.dispose();
    _bannerAd = null;
  }

  // ============ INTERSTITIAL ADS ============

  /// Obter ID do interstitial de anúncio para a plataforma atual
  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdsConfig.shouldUseTestAds 
        ? AdsConfig.testInterstitialAdUnitIdAndroid 
        : AdsConfig.interstitialAdUnitIdAndroid;
    } else if (Platform.isIOS) {
      return AdsConfig.shouldUseTestAds 
        ? AdsConfig.testInterstitialAdUnitIdIos 
        : AdsConfig.interstitialAdUnitIdIos;
    }
    throw UnsupportedError('Plataforma não suportada');
  }

  /// Criar e carregar um interstitial ad
  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  /// Mostrar interstitial ad se estiver disponível
  Future<bool> showInterstitialAd() async {
    if (_interstitialAd == null) {
      return false;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        // Criar novo ad para o próximo uso
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        _createInterstitialAd();
      },
    );

    try {
      await _interstitialAd!.show();
      _interstitialAd = null;
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============ CLEANUP ============

  /// Descarregar todos os anúncios
  Future<void> dispose() async {
    await _bannerAd?.dispose();
    await _interstitialAd?.dispose();

    _bannerAd = null;
    _interstitialAd = null;
  }
}
