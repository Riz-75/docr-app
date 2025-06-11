import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image2text/screens/home.dart';
import 'package:image2text/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  AppOpenAd? appOpenAd;

  loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: kidOpenAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          appOpenAd!.show();
          appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              appOpenAd?.dispose();
            },
            onAdWillDismissFullScreenContent: (ad) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              appOpenAd?.dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              appOpenAd?.dispose();
            },
          );
        },
        onAdFailedToLoad: (e) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          appOpenAd?.dispose();
          return;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    _animationController!.repeat(reverse: true);
    loadAppOpenAd();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFE0DAFC),
                Color(0xFFC0D8FA),
              ], // Adjust colors as desired
            ),
          ),
        ),
        Center(
          child: SizedBox(
            height: 96,
            child: AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) => Transform(
                transform: Matrix4.translationValues(0.0, _animation!.value * 48.0, 0.0),
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
