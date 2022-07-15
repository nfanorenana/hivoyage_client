import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/schedule.dart';
import 'package:hivoyage/pages/layout.dart';
import 'package:hivoyage/providers/services.dart';
import 'package:hivoyage/util/widgets.dart';
import 'package:intl/intl.dart';

class SeatSelector extends StatefulWidget {
  Schedule schedule;
  List<String> seatMap;
  Map<String, dynamic> seatPrice;
  List<String> unavailableSeat;
  double exchangeValue;
  SeatSelector({
    Key key,
    this.schedule,
    this.seatMap,
    this.seatPrice,
    this.unavailableSeat,
    this.exchangeValue,
  }) : super(key: key);

  @override
  _SeatSelectorState createState() => _SeatSelectorState();
}

class _SeatSelectorState extends State<SeatSelector> {
  int price;
  List<int> selectedSeatPrice;
  List<String> selectedSeat;
  List<String> selectedSeatCategory;
  NumberFormat nbformat;

  @override
  void initState() {
    super.initState();
    selectedSeat = [];
    selectedSeatPrice = [];
    selectedSeatCategory = [];
    price = 0;
    nbformat = NumberFormat('#,###,###.00');
  }

  Widget seatList() {
    var _seatMap = widget.seatMap;
    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12.withOpacity(0.1),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: blueAccent,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    color: Colors.black12.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: legend()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          for (int x = 0; x < _seatMap.length; x++)
                            Container(
                              child: Row(
                                children: <Widget>[
                                  for (int y = 0;
                                      y < _seatMap.first.length;
                                      y++)
                                    for (var seat in _seatMap[x][y].runes)
                                      Expanded(
                                        flex: x == 0 || x == _seatMap.length - 1
                                            ? 2
                                            : 1,
                                        child: String.fromCharCode(seat) == '_'
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  setState(
                                                    () {
                                                      widget.unavailableSeat
                                                              .contains(String
                                                                      .fromCharCodes([
                                                                    65 + y
                                                                  ]) +
                                                                  '_' +
                                                                  '${x + 1}')
                                                          ? Flushbar(
                                                              title: "Erreur",
                                                              message:
                                                                  "Place déjà prise",
                                                              backgroundColor:
                                                                  Colors.red,
                                                              flushbarPosition:
                                                                  FlushbarPosition
                                                                      .BOTTOM,
                                                              flushbarStyle:
                                                                  FlushbarStyle
                                                                      .FLOATING,
                                                              reverseAnimationCurve:
                                                                  Curves
                                                                      .decelerate,
                                                              forwardAnimationCurve:
                                                                  Curves
                                                                      .elasticOut,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                              isDismissible:
                                                                  false,
                                                            ).show(context)
                                                          : selectedSeat.contains(
                                                                  String.fromCharCodes([
                                                                        65 + y
                                                                      ]) +
                                                                      '_' +
                                                                      '${x + 1}')
                                                              ? {
                                                                  selectedSeatPrice
                                                                      .removeAt(
                                                                    selectedSeat.indexOf(String
                                                                            .fromCharCodes([
                                                                          65 + y
                                                                        ]) +
                                                                        '_' +
                                                                        '${x + 1}'),
                                                                  ),
                                                                  selectedSeatCategory
                                                                      .removeAt(
                                                                    selectedSeat.indexOf(String
                                                                            .fromCharCodes([
                                                                          65 + y
                                                                        ]) +
                                                                        '_' +
                                                                        '${x + 1}'),
                                                                  ),
                                                                  selectedSeat.remove(
                                                                      String.fromCharCodes([
                                                                            65 +
                                                                                y
                                                                          ]) +
                                                                          '_' +
                                                                          '${x + 1}'),
                                                                  String.fromCharCode(seat) ==
                                                                          'f'
                                                                      ? price -=
                                                                          widget.seatPrice['f']
                                                                              [
                                                                              'price']
                                                                      : price -=
                                                                          widget.seatPrice['e']
                                                                              [
                                                                              'price'],
                                                                }
                                                              : {
                                                                  selectedSeat.add(
                                                                      String.fromCharCodes([
                                                                            65 +
                                                                                y
                                                                          ]) +
                                                                          '_' +
                                                                          '${x + 1}'),
                                                                  String.fromCharCode(
                                                                              seat) ==
                                                                          'f'
                                                                      ? {
                                                                          price +=
                                                                              widget.seatPrice['f']['price'],
                                                                          selectedSeatPrice.add(widget.seatPrice['f']
                                                                              [
                                                                              'price']),
                                                                          selectedSeatCategory.add(widget.seatPrice['f']
                                                                              [
                                                                              'category']),
                                                                        }
                                                                      : {
                                                                          price +=
                                                                              widget.seatPrice['e']['price'],
                                                                          selectedSeatPrice.add(widget.seatPrice['e']
                                                                              [
                                                                              'price']),
                                                                          selectedSeatCategory.add(widget.seatPrice['e']
                                                                              [
                                                                              'category']),
                                                                        }
                                                                };
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  // height: size.width / 11 - 10,
                                                  margin: EdgeInsets.all(5),
                                                  child: seatState(
                                                      selectedSeat,
                                                      (String.fromCharCodes(
                                                              [65 + y]) +
                                                          '_' +
                                                          '${x + 1}'),
                                                      seat,
                                                      widget.unavailableSeat),
                                                ),
                                              ),
                                      ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.black12.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Prix ',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey.shade600,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 20.w),
                                    Text(
                                      price == 0
                                          ? ''
                                          : 'Ar ${nbformat.format(price)}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey.shade800,
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    'Valider',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: blueAccent,
                                  ),
                                  onPressed: () => _onValidButtonPressed(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      designSize: const Size(480, 640),
    );
  }

  Widget seatState(
    List<String> selectedSeat,
    String id,
    int seat,
    List<String> unavailableSeat,
  ) {
    if (unavailableSeat.contains(id)) {
      return BuildSeats.reservedSeat();
    }
    if (String.fromCharCode(seat) == 'f') {
      if (selectedSeat.contains(id)) {
        return BuildSeats.firstSelectedSeat();
      } else {
        return BuildSeats.firstAvailable();
      }
    } else {
      if (selectedSeat.contains(id)) {
        return BuildSeats.economySelectedSeat();
      } else {
        return BuildSeats.economyAvailable();
      }
    }
  }

  Widget legend() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            BuildSeats.firstAvailable(),
            SizedBox(height: 8.h),
            Text(
              'Première classe',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade800,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
          Column(children: [
            BuildSeats.economyAvailable(),
            SizedBox(height: 8.h),
            Text(
              'Classe économique',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade800,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
          Column(children: [
            BuildSeats.reservedSeat(),
            SizedBox(height: 8.h),
            Text(
              'Déjà réservée',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade800,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width,
        ),
        Positioned(
          child: Container(
            width: size.width,
            child: seatList(),
          ),
        ),
      ],
    );
  }

  valid() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: tokenizationKey,
      collectDeviceData: true,
      paypalRequest: BraintreePayPalRequest(
        amount: (price * widget.exchangeValue).toString(),
      ),
      cardEnabled: true,
    );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);
    if (result != null) {
      final Future<Map<String, dynamic>> res = bookAndPayWithPayPal(
        result,
        widget.schedule,
        selectedSeat,
        selectedSeatPrice,
        selectedSeatCategory,
        price,
      );
      res.then((response) {
        if (response['status']) {
          Flushbar(
            // title: "",
            message: "Place(s) reservée(s) avec succès",
            backgroundColor: Colors.green,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            duration: const Duration(seconds: 2),
            isDismissible: false,
          ).show(context).then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Layout(),
                  ),
                ),
              );
        } else {
          Flushbar(
            // title: "Erreur",
            message: response['message'],
            backgroundColor: Colors.red,
            flushbarPosition: FlushbarPosition.BOTTOM,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            duration: const Duration(seconds: 2),
            isDismissible: false,
          ).show(context);
        }
      });
    }
  }

  _onValidButtonPressed() {
    if (selectedSeat.isNotEmpty) {
      valid();
    } else {
      Flushbar(
        title: "Erreur",
        message: "Veuillez selectionner au moins une place",
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        duration: const Duration(seconds: 2),
        isDismissible: false,
      ).show(context);
    }
  }
}
