import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image2text/constants.dart';
import 'package:image2text/screens/result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image2text/brains/ads_brain.dart';
import 'package:image2text/brains/ocr_brain.dart';
import 'package:image2text/custom_widgets/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var inputFile;
  double sWidth = 0;
  double sHeight = 0;
  BannerAd? bannerAd;
  bool isLoading = false;
  bool isBannerLoaded = false;
  OCRBrain ocrBrain = OCRBrain();
  ADSBrain adsBrain = ADSBrain();

  loadBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: kidBannerAd,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isBannerLoaded = true;
        });
        return;
      }, onAdFailedToLoad: (ad, e) {
        setState(() {
          isBannerLoaded = false;
        });
        bannerAd!.dispose();
      }),
      request: const AdRequest(),
    );
    bannerAd?.load();
  }

  void start(ImageSource? source) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (source != null) {
        inputFile = await ocrBrain.getImage(source);
      } else {
        inputFile = await ocrBrain.getPDF();
      }
      if (inputFile != null) {
        if (adsBrain.isInterstitialLoaded) adsBrain.interstitialAd?.show();
        await Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(inputFile)));
        if (!isBannerLoaded) loadBannerAd();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    adsBrain.loadInterstitialAd();
    loadBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width.ceilToDouble();
    //double sHeight = MediaQuery.of(context).size.height.ceilToDouble();
    if (!adsBrain.isInterstitialLoaded) adsBrain.loadInterstitialAd();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF412795),
        centerTitle: true,
        title: const Text('DOCR'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFE0DAFC),
              Color(0xFFC0D8FA),
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xFF412795),
              ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: sWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: HomeCard(
                                    onTap: () {
                                      start(ImageSource.camera);
                                    },
                                    sWidth: sWidth,
                                    icon: Icons.camera_alt_rounded,
                                    text: 'Camera',
                                  ),
                                ),
                                Expanded(
                                  child: HomeCard(
                                    onTap: () {
                                      start(ImageSource.gallery);
                                    },
                                    sWidth: sWidth,
                                    icon: Icons.photo_rounded,
                                    text: 'Gallery',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: HomeCard(
                                    onTap: () async {
                                      start(null);
                                    },
                                    sWidth: sWidth,
                                    icon: Icons.picture_as_pdf_rounded,
                                    text: 'Scan PDF',
                                  ),
                                ),
                                Expanded(
                                  child: HomeCard(
                                    onTap: () async {
                                      if (adsBrain.isInterstitialLoaded) {
                                        adsBrain.interstitialAd?.show();
                                      } else {
                                        adsBrain.loadInterstitialAd();
                                      }
                                    },
                                    sWidth: sWidth,
                                    text: 'more\ncoming\nsoon!',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  isBannerLoaded
                      ? SizedBox(
                          height: 100,
                          child: AdWidget(ad: bannerAd!),
                        )
                      : const SizedBox()
                ],
              ),
      ),
    );
  }
}
