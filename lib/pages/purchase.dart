import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/domain/city.dart';
import 'package:hivoyage/domain/schedule.dart';
import 'package:hivoyage/pages/search_result.dart';
import 'package:hivoyage/providers/services.dart';
import 'package:hivoyage/util/app_url.dart';
import 'package:hivoyage/util/storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Purchase extends StatefulWidget {
  const Purchase({Key key}) : super(key: key);

  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  final formKey = GlobalKey<FormState>();

  AutoCompleteTextField d_searchTextField;
  AutoCompleteTextField a_searchTextField;
  GlobalKey<AutoCompleteTextFieldState<City>> d_key = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<City>> a_key = GlobalKey();
  static List<City> cities = <City>[];
  static List<Schedule> schedules = <Schedule>[];
  bool loading = true;

  String departure;
  String arrival;
  String date;

  final TextEditingController _dateCtrl = TextEditingController();

  void getCities() async {
    String token = await UserPreferences().getToken();
    try {
      Response response = await post(
        Uri.parse(AppUrl.city),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final parsed =
            json.decode(response.body)['city'].cast<Map<String, dynamic>>();
        cities = parsed.map<City>((json) => City.fromJson(json)).toList();
        setState(() {
          loading = false;
        });
      } else {}
    } catch (e) {}
  }

  _onSearchButtonPressed() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      final Future<Map<String, dynamic>> response = searchSchedule(
          d_searchTextField.textField.controller.text,
          a_searchTextField.textField.controller.text,
          _dateCtrl.text);

      departure = d_searchTextField.textField.controller.text;
      arrival = a_searchTextField.textField.controller.text;
      date = _dateCtrl.text;
      // setState(() {
      response.then((responseData) {
        inspect(responseData);
        if (responseData['status']) {
          schedules = responseData['schedules'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResult(
                schedules: schedules,
                departure: departure,
                arrival: arrival,
                date: date,
              ),
            ),
          );
        } else {
          Flushbar(
            message: responseData['message'],
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            isDismissible: false,
          ).show(context);
        }
        // });
      });
    } else {
      Flushbar(
        title: "Formulaire invalide",
        message: "Vueillez remplir correctement le formulaire",
        duration: Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getCities();
    _dateCtrl.text = "";
  }

  Widget getTextField(
      {String hint, Icon prefixIcon, TextInputType keyboardType}) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        filled: true,
        // fillColor: textFieldColor,
        fillColor: Color(0xffF5F6FA),
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget row(City city) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Text(
            city.cityRegistration,
            style: GoogleFonts.montserrat(
              fontSize: 22.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Text(
                  city.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF3594DD),
                  Color(0xFF4563DB),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0.h, horizontal: 20.0.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          loading
                              ? getTextField(
                                  hint: 'Départ (ville)',
                                  prefixIcon: Icon(
                                    Icons.departure_board_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  keyboardType: TextInputType.name,
                                )
                              : d_searchTextField = AutoCompleteTextField<City>(
                                  key: d_key,
                                  clearOnSubmit: false,
                                  suggestions: cities,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 14.h),
                                    filled: true,
                                    // fillColor: textFieldColor,
                                    fillColor: const Color(0xffF5F6FA),
                                    prefixIcon: Icon(
                                      Icons.departure_board,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Départ (ville)',
                                    hintStyle: GoogleFonts.montserrat(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  itemFilter: (item, query) {
                                    return item.name
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a.name.compareTo(b.name);
                                  },
                                  itemSubmitted: (item) {
                                    d_searchTextField
                                        .textField.controller.text = item.name;
                                  },
                                  itemBuilder: (context, item) {
                                    return row(item);
                                  },
                                ),
                          SizedBox(
                            height: 8.0.h,
                          ),
                          loading
                              ? getTextField(
                                  hint: 'Arrivée (ville)',
                                  prefixIcon: Icon(
                                    CupertinoIcons.location,
                                    color: Colors.grey.shade600,
                                  ),
                                  keyboardType: TextInputType.name,
                                )
                              : a_searchTextField = AutoCompleteTextField<City>(
                                  key: a_key,
                                  clearOnSubmit: false,
                                  suggestions: cities,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent, width: 0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 14.h),
                                    filled: true,
                                    // fillColor: textFieldColor,
                                    fillColor: const Color(0xffF5F6FA),
                                    prefixIcon: Icon(
                                      CupertinoIcons.location_solid,
                                      color: Colors.grey.shade600,
                                    ),
                                    hintText: 'Arrivée (ville)',
                                    hintStyle: GoogleFonts.montserrat(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  keyboardType: TextInputType.name,
                                  itemFilter: (item, query) {
                                    return item.name
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a.name.compareTo(b.name);
                                  },
                                  itemSubmitted: (item) {
                                    a_searchTextField
                                        .textField.controller.text = item.name;
                                  },
                                  itemBuilder: (context, item) {
                                    return row(item);
                                  },
                                ),
                          SizedBox(
                            height: 8.0.h,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 14.h),
                              filled: true,
                              // fillColor: textFieldColor,
                              fillColor: Color(0xffF5F6FA),
                              prefixIcon: Icon(
                                CupertinoIcons.calendar,
                                color: Colors.grey.shade600,
                              ),
                              hintText: 'Date de départ',
                              hintStyle: GoogleFonts.montserrat(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            validator: (value) => value.isEmpty
                                ? "Veuillez selectionner une date"
                                : null,
                            controller: _dateCtrl,
                            readOnly: true,
                            onTap: () async {
                              DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                                locale: const Locale("fr", "FR"),
                              );

                              if (pickedDate != null) {
                                print(pickedDate);
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate);
                                setState(() {
                                  _dateCtrl.text = formattedDate;
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () => _onSearchButtonPressed(),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white30),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 14.h),
                                ),
                                textStyle: MaterialStateProperty.all(
                                  GoogleFonts.montserrat(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 10.w),
                                  Text("Rechercher"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.0.h),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
