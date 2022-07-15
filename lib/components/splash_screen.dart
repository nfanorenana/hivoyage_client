import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        body: AnimatedSplashScreen(
          backgroundColor: blue,
          duration: 3000,
          splash: Container(
            // color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(15.0.r),
                  padding: EdgeInsets.all(3.0.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    'hivoyage',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          splashTransition: SplashTransition.rotationTransition,
          pageTransitionType: PageTransitionType.scale,
        ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
