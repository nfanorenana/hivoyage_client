import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/qr_ticket.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TripTicket extends StatefulWidget {
  QrTicket qrTicket;
  String qrData;
  TripTicket({Key key, this.qrTicket, this.qrData}) : super(key: key);

  @override
  _TripTicketState createState() => _TripTicketState();
}

class _TripTicketState extends State<TripTicket> {
  NumberFormat nbformat;

  @override
  void initState() {
    super.initState();
    nbformat = NumberFormat('#,###,###.00');
    inspect(widget.qrTicket);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          backgroundColor: blue,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Détails de la réservation',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: Container(
              padding: EdgeInsets.fromLTRB(0.w, 0.h, 32.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Ar ${nbformat.format(double.parse(widget.qrTicket.totalAmount))}',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 32.h),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(26.r),
                  margin: EdgeInsets.fromLTRB(26.w, 26.h, 26.w, 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Center(
                          //   child: Image.asset(''),
                          // ),
                          SizedBox(height: 18.h),
                          Text(
                            widget.qrTicket.dateDeparture,
                            style: GoogleFonts.montserrat(
                              fontSize: 30.sp,
                            ),
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'De',
                                    style: GoogleFonts.montserrat(
                                      color: blueAccent,
                                    ),
                                  ),
                                  Text(
                                    widget.qrTicket.departureCity,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                  SizedBox(height: 18.h),
                                  Text(
                                    'à'.toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      color: blueAccent,
                                    ),
                                  ),
                                  Text(
                                    widget.qrTicket.arrivalCity,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Départ',
                                    style: GoogleFonts.montserrat(
                                      color: blueAccent,
                                    ),
                                  ),
                                  Text(
                                    widget.qrTicket.timeDeparture,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                  SizedBox(height: 28),
                                  Text(
                                    'Arrivée',
                                    style: GoogleFonts.montserrat(
                                      color: blueAccent,
                                    ),
                                  ),
                                  Text(
                                    widget.qrTicket.timeArrival,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 18.h),
                      const Divider(),
                      SizedBox(height: 18.h),
                      Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Passager',
                                    style: GoogleFonts.montserrat(
                                      color: blueAccent,
                                    ),
                                  ),
                                  Text(
                                    widget.qrTicket.customerName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(height: 18.h),
                          Row(
                            children: [
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       'Gate',
                              //       style: TextStyle(color: blueAccent),
                              //     ),
                              //     Text(
                              //       '2H',
                              //       style: TextStyle(fontSize: 18.sp),
                              //     ),
                              //   ],
                              // ),
                              // Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Siège',
                                    style: GoogleFonts.montserrat(
                                      color: blueAccent,
                                    ),
                                  ),
                                  Text(
                                    widget.qrTicket.seat,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(flex: 2),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      Divider(),
                      SizedBox(height: 18.h),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: QrImage(
                            data: widget.qrData,
                            size: 200,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'ID du billet: ${widget.qrTicket.ticketNumber}',
                  style: GoogleFonts.montserrat(
                    color: blueAccent,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
