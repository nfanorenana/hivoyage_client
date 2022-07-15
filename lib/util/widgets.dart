import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

MaterialButton longButtons(
    {String title,
    Function fun,
    Color color = const Color(0xfff063057),
    Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(),
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent, width: 0),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    // fillColor: textFieldColor,
    fillColor: const Color(0xffF5F6FA),
    prefixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
    hintText: hintText,
    hintStyle: GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  );
}

MaterialButton loginButton(
    {String title,
    Function fun,
    Color color = const Color(0xfff063057),
    Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: fun,
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(),
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );
}

class BuildSeats {
  static Widget economyAvailable() {
    return Image.asset(
      'assets/images/seats/economy-available.png',
      width: 50.w,
      height: 50.h,
    );
  }

  static Widget economySelectedSeat() {
    return Image.asset(
      'assets/images/seats/economy-selected.png',
      width: 50.w,
      height: 50.h,
    );
  }

  static Widget firstAvailable() {
    return Image.asset(
      'assets/images/seats/first-available.png',
      width: 50.w,
      height: 50.h,
    );
  }

  static Widget firstSelectedSeat() {
    return Image.asset(
      'assets/images/seats/first-selected.png',
      width: 50.w,
      height: 50.h,
    );
  }

  static Widget reservedSeat() {
    return Image.asset(
      'assets/images/seats/unavailable.png',
      width: 50.w,
      height: 50.h,
    );
  }
}
