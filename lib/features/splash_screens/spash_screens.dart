import 'package:center_for_biblical_studies/features/authentication/login_page.dart';
import 'package:center_for_biblical_studies/page/main_page.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/shared/custom_button.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  _checkAuthAndNavigate() async {
    // Check if user is already logged in
    bool isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
      // User is signed in, skip splash screens and go directly to MainPage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } else {
      // User is not signed in, show splash screens
      await Future.delayed(const Duration(milliseconds: 1500), () {});
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreenTwo()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A1C00),
      body: Center(
        child: Image.asset("assets/images/cbs_logo.png"),
      ),
    );
  }
}

class SplashScreenTwo extends StatefulWidget {
  const SplashScreenTwo({super.key});

  @override
  State<SplashScreenTwo> createState() => _SplashScreenTwoState();
}

class _SplashScreenTwoState extends State<SplashScreenTwo> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List images = [
    "img.png",
    "img.png",
    "img_1.png",
  ];

  List text = [
    "De nombreux cours, livres et Bibles à votre disposition",
    "Etudiez de n'importe où, à n'importe quelle heure, à votre convenance",
    "Acquérez la connaissance sur les différents courants doctrinaux",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbsColors.white,
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (_, index) {
          return SizedBox(
            height: SizeConfig().heightSize(context, 2),
            width: SizeConfig().widthSize(context, 1),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      child: Image.asset("assets/images/${images[index]}")),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            text[index],
                            textAlign: TextAlign.center,
                            style: largeStyle32Bold,
                          ),
                        ),
                        gapH12,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (indexDots) => Container(
                              margin: const EdgeInsets.only(right: 2),
                              height: 8,
                              width: _currentPage == indexDots ? 25 : 8,
                              decoration: BoxDecoration(
                                  color: _currentPage == indexDots
                                      ? CbsColors.primaryBrown
                                      : CbsColors.primaryBrown
                                          .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        gapH12,
                        CustomButton(
                          width: 317,
                          height: 58,
                          onPressed: () {
                            if (index == images.length - 1) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            } else {
                              // Navigate to next page
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          bgColor: CbsColors.primaryBrown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                index != images.length - 1
                                    ? "Suivant"
                                    : "Commencer",
                                style: smallStyle18.copyWith(
                                    color: CbsColors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH12,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
