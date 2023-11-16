import 'package:flutter/material.dart';
// import 'package:flutter_samples/models/samples.dart';
import 'package:flutter_samples/samples/animations/animation_samples_list.dart';
import 'package:flutter_samples/samples/animations/custom_caret/custom_caret.dart';
// import 'package:flutter_samples/screens/samples_list_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/home.dart';
import 'package:flutter_samples/samples/animations/grid_magnification/grid_magnification.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:ui';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:rive/rive.dart';
import 'package:flutter_samples/samples/ui/rive_app/theme.dart';
import 'package:flutter_samples/samples/ui/rive_app/on_boarding/signin_view.dart';
import 'package:flutter_samples/samples/ui/rive_app/assets.dart' as app_assets;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        primarySwatch: Colors.blue,
      ),
      routes: {
        RiveAppHome.route: (context) => const RiveAppHome(),
        AnimationSamplesList.route: (context) => const AnimationSamplesList(),
        GridMagnification.route: (context) => const GridMagnification(),
        CustomCaret.route: (context) => const CustomCaret(),
      },
      debugShowCheckedModeBanner: false,
      home: const OnBoardingView(),
    );
  }
}

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key, this.closeModal}) : super(key: key);

  // Close modal callback for any screen that uses this as a modal
  final Function? closeModal;

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> with TickerProviderStateMixin {
  // Animation controller that shows the sign up modal as well as translateY boarding content together
  AnimationController? _signInAnimController;

  // Control touch effect animation for the "Start the Course" button
  late RiveAnimationController _btnController;

  @override
  void initState() {
    super.initState();
    _signInAnimController = AnimationController(duration: const Duration(milliseconds: 350), upperBound: 1, vsync: this);

    _btnController = OneShotAnimation("active", autoplay: false);

    const springDesc = SpringDescription(
      mass: 0.1,
      stiffness: 40,
      damping: 5,
    );

    _btnController.isActiveChanged.addListener(() {
      if (!_btnController.isActive) {
        final springAnim = SpringSimulation(springDesc, 0, 1, 0);
        _signInAnimController?.animateWith(springAnim);
      }
    });
  }

  @override
  void dispose() {
    _signInAnimController?.dispose();
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Center(
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Transform.translate(
                offset: const Offset(200, 100),
                child: Image.asset(app_assets.spline, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: const RiveAnimation.asset(app_assets.shapesRiv),
        ),
        AnimatedBuilder(
          animation: _signInAnimController!,
          builder: (context, child) {
            return Transform(transform: Matrix4.translationValues(0, -50 * _signInAnimController!.value, 0), child: child);
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 80, 40, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 260,
                            padding: const EdgeInsets.only(bottom: 16),
                            child: const Text(
                              "You can now learn Faster",
                              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          Text(
                            "Lorem ipsum dolor sit amet consectetur. Aenean fames nec consectetur  our is it pellentesque. Lorem ipsum dolor sit ame..",
                            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.7), fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // const Spacer(),
                  GestureDetector(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 236,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            RiveAnimation.asset(
                              app_assets.buttonRiv,
                              fit: BoxFit.cover,
                              controllers: [
                                _btnController
                              ],
                            ),
                            Center(
                              child: Transform.translate(
                                offset: const Offset(4, 4),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.arrow_forward_rounded),
                                    SizedBox(width: 4),
                                    Text(
                                      "Get Started",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _btnController.isActive = true;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _signInAnimController!,
            builder: (context, child) {
              return Stack(
                children: [
                  Positioned(
                      top: 100 - (_signInAnimController!.value * 200),
                      right: 20,
                      child: SafeArea(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(36 / 2),
                          minSize: 36,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(36 / 2),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 10))
                              ],
                            ),
                          ),
                          onPressed: () {
                            widget.closeModal!();
                          },
                        ),
                      )),
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0.4 * _signInAnimController!.value,
                        child: Container(color: RiveAppTheme.shadow),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(
                      0,
                      -MediaQuery.of(context).size.height * (1 - _signInAnimController!.value),
                    ),
                    child: child,
                  ),
                ],
              );
            },
            child: SignInView(
              closeModal: () {
                _signInAnimController?.reverse();
              },
            ),
          ),
        ),
      ]),
    );
  }
}
