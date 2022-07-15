import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/ticket.dart';
import 'package:hivoyage/pages/trip_ticket.dart';
import 'package:hivoyage/providers/services.dart';

class TicketList extends StatefulWidget {
  const TicketList({Key key}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  onTapTicket(int ticketId) {
    final Future<Map<String, dynamic>> res = ticketDetail(ticketId);

    res.then((response) {
      if (response['status']) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripTicket(
              qrTicket: response['qrticket'],
              qrData: response['qrdata'],
            ),
          ),
        );
      }
    });
    print(ticketId);
  }

  final Future<Map<String, dynamic>> _loadTickets =
      Future<Map<String, dynamic>>.delayed(
    const Duration(milliseconds: 1),
    () => loadAllTickets(),
  );

  Widget ticketWidget() {
    return FutureBuilder(
      future: _loadTickets,
      builder: (context, ticketSnap) {
        if (ticketSnap.hasData) {
          if (ticketSnap.data['status']) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: ticketSnap.data['ticket'].length,
              itemBuilder: (context, index) {
                Ticket ticket = ticketSnap.data['ticket'][index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => onTapTicket(ticket.id),
                        child: Container(
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
                                spreadRadius: 2.r,
                                blurRadius: 4.r,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      // child: Image.asset(
                                      //   'assets/images/companies_logo/gol_logo.png',
                                      // ),
                                      ),
                                  SizedBox(height: 28.h),
                                  Text(
                                    ticket.dateDeparture,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 25.sp,
                                    ),
                                  ),
                                  SizedBox(height: 28.h),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'De',
                                            style: GoogleFonts.montserrat(
                                              color: blueAccent,
                                            ),
                                          ),
                                          Text(
                                            ticket.from,
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          SizedBox(height: 28.h),
                                          Text(
                                            'à'.toUpperCase(),
                                            style: GoogleFonts.montserrat(
                                              color: blueAccent,
                                            ),
                                          ),
                                          Text(
                                            ticket.to,
                                            style: GoogleFonts.montserrat(),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Départ',
                                            style: GoogleFonts.montserrat(
                                              color: blueAccent,
                                            ),
                                          ),
                                          Text(
                                            ticket.timeDeparture,
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          SizedBox(height: 28.h),
                                          Text(
                                            'Arrivée',
                                            style: GoogleFonts.montserrat(
                                              color: blueAccent,
                                            ),
                                          ),
                                          Text(
                                            ticket.timeArrival,
                                            style: GoogleFonts.montserrat(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              child: Text(
                ticketSnap.data['message'],
                style: GoogleFonts.montserrat(),
              ),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          title: Text(
            'Billets',
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 25.0.sp,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0.h,
        ),
        body: Center(child: ticketWidget()),
      ),
      designSize: const Size(480, 640),
    );
  }
}
