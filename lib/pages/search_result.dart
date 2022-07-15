import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/components/seat_selector.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/schedule.dart';
import 'package:hivoyage/pages/layout.dart';
import 'package:hivoyage/providers/services.dart';
import 'package:hivoyage/util/separator.dart';
import 'package:intl/intl.dart';

class SearchResult extends StatefulWidget {
  List<Schedule> schedules = <Schedule>[];
  String departure;
  String arrival;
  String date;
  SearchResult(
      {Key key, this.schedules, this.departure, this.arrival, this.date})
      : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  getScheduleData(Schedule schedule) {
    final Future<Map<String, dynamic>> res = scheduleData(schedule);
    res.then((response) {
      if (response['status']) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SeatSelector(
              schedule: response['schedule'],
              seatMap: response['seat_map'],
              seatPrice: response['seat_price'],
              unavailableSeat: response['unavailable_seat'],
              exchangeValue: response['exchange_value'],
            ),
          ),
        );
      }
    });
  }

  SliverList _getSlivers(List myList, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: getContentList(myList[index]),
          );
        },
        childCount: myList.length,
      ),
    );
  }

  Widget getContentList(Schedule schedule) {
    return Container(
      margin: EdgeInsets.only(top: 6.h, bottom: 6.h),
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Heure de départ',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 22.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Text(
                          schedule.departureTime,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  schedule.classLogo,
                  width: 125.w,
                  height: 125.h,
                ),
              ],
            ),
            Separator(
              height: 2.h,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                schedule.tarif,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          getScheduleData(schedule);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: false,
              floating: true,
              expandedHeight: 250.0,
              backgroundColor: blue,
              bottom: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Layout(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: blue,
                elevation: 0,
                title: Container(
                  color: blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.departure} ',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.sp,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                              Text(
                                ' ${widget.arrival}',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          Text(
                            DateFormat('d MMM yyyy')
                                .format(DateTime.parse(widget.date)),
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _getSlivers(widget.schedules, context),
          ],
        ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
