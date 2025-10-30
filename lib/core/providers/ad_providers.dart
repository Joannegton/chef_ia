import 'package:chef_ia/core/services/ad_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Provider para o serviço de anúncios
final adServiceProvider = Provider<AdService>((ref) {
  return AdService();
});

/// Provider para banner ad
final bannerAdProvider = FutureProvider<BannerAd?>((ref) async {
  final adService = ref.watch(adServiceProvider);
  return await adService.createBannerAd();
});
