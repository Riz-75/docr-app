import 'package:image2text/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADSBrain {
  InterstitialAd? interstitialAd;
  bool isInterstitialLoaded = false;

  loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: kidInterAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialLoaded = true;
          interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              isInterstitialLoaded = false;
              interstitialAd?.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              isInterstitialLoaded = false;
              interstitialAd?.dispose();
            },
          );
        },
        onAdFailedToLoad: (e) {
          isInterstitialLoaded = false;
          interstitialAd?.dispose();
          return;
        },
      ),
    );
  }
}
