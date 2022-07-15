import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/ticket.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/pages/settings.dart';
import 'package:hivoyage/providers/services.dart';
import 'package:hivoyage/util/storage.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;
  Map<String, dynamic> tickets;

  bool showPassword = false;
  final Future<User> _loadUser = Future<User>.delayed(
    const Duration(milliseconds: 1),
    () => UserPreferences().getUser(),
  );

  final Future<Map<String, dynamic>> _loadTickets =
      Future<Map<String, dynamic>>.delayed(
    const Duration(milliseconds: 1),
    () => loadAllUsedTickets(),
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          title: Text(
            'Profil',
            style: GoogleFonts.montserrat(
              color: Colors.black54,
              fontSize: 25.0.sp,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              color: blueAccent,
              tooltip: 'Paramètres',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0.0.h,
        ),
        backgroundColor: const Color(0xffffffff),
        body: CustomScrollView(slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: const Color(0xffffffff),
            flexibleSpace: FlexibleSpaceBar(
              title: Expanded(
                child: FutureBuilder(
                  future: Future.wait([
                    _loadUser.then((value) => user = value),
                    _loadTickets.then((value) => tickets = value),
                  ]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[
                        Text(
                          snapshot.data[0].name,
                          style: GoogleFonts.montserrat(
                            fontSize: 24.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ];
                    } else {
                      children = <Widget>[
                        Text(
                          '..',
                          style: GoogleFonts.montserrat(),
                        ),
                      ];
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    );
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: Future.wait([
                      _loadUser.then((value) => user = value),
                      _loadTickets.then((value) => tickets = value),
                    ]),
                    builder: (context, ticketSnap) {
                      if (ticketSnap.hasData) {
                        if (ticketSnap.data[1]['status']) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            itemCount: ticketSnap.data[1].length,
                            itemBuilder: (context, index) {
                              Ticket ticket =
                                  ticketSnap.data[1]['ticket'][index];
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.all(26.r),
                                        margin: EdgeInsets.fromLTRB(
                                            26.w, 26.h, 26.w, 12.h),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.r),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2.r,
                                              blurRadius: 4.r,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'De',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      blueAccent),
                                                        ),
                                                        Text(
                                                          ticket.from,
                                                          style: GoogleFonts
                                                              .montserrat(),
                                                        ),
                                                        SizedBox(height: 28.h),
                                                        Text(
                                                          'A',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      blueAccent),
                                                        ),
                                                        Text(
                                                          ticket.to,
                                                          style: GoogleFonts
                                                              .montserrat(),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Départ',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      blueAccent),
                                                        ),
                                                        Text(
                                                          ticket.timeDeparture,
                                                          style: GoogleFonts
                                                              .montserrat(),
                                                        ),
                                                        SizedBox(height: 28.h),
                                                        Text(
                                                          'Arrivée',
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      blueAccent),
                                                        ),
                                                        Text(ticket.timeArrival,
                                                            style: GoogleFonts
                                                                .montserrat()),
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
                              ticketSnap.data[1]['message'],
                              style: GoogleFonts.montserrat(),
                            ),
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ]
            // Container(
            //   constraints: BoxConstraints(
            //     maxHeight: MediaQuery.of(context).size.height,
            //     minWidth: MediaQuery.of(context).size.width,
            //   ),
            //   padding: EdgeInsets.only(left: 16.w, top: 25.h, right: 16.w),
            //   child: GestureDetector(
            //     onTap: () {
            //       FocusScope.of(context).unfocus();
            //     },
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Expanded(
            //           flex: 1,
            //           child: ListView(
            //             children: <Widget>[
            //               Container(
            //                 color: const Color(0xffffffff),
            //                 child: Padding(
            //                   padding: EdgeInsets.all(8.0.w),
            //                   child: Row(
            //                     children: <Widget>[
            //                       FutureBuilder(
            //                         future: Future.wait([
            //                           _loadUser.then((value) => user = value),
            //                           _loadTickets
            //                               .then((value) => tickets = value),
            //                         ]),
            //                         builder: (BuildContext context,
            //                             AsyncSnapshot snapshot) {
            //                           List<Widget> children;
            //                           if (snapshot.hasData) {
            //                             children = <Widget>[
            //                               Container(
            //                                 width: 105.w,
            //                                 height: 105.h,
            //                                 decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       width: 2.w,
            //                                       color: Theme.of(context)
            //                                           .scaffoldBackgroundColor),
            //                                   shape: BoxShape.circle,
            //                                   image: DecorationImage(
            //                                     fit: BoxFit.cover,
            //                                     image: snapshot.data[0]
            //                                                 .photoProfile ==
            //                                             null
            //                                         ? const NetworkImage(
            //                                             "https://bip.cnrs.fr/wp-content/uploads/2019/11/user.jpg",
            //                                           )
            //                                         : NetworkImage(
            //                                             snapshot
            //                                                 .data[0].photoProfile,
            //                                           ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ];
            //                           } else {
            //                             children = <Widget>[
            //                               Container(
            //                                 width: 105.w,
            //                                 height: 105.h,
            //                                 decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                       width: 2.w,
            //                                       color: Theme.of(context)
            //                                           .scaffoldBackgroundColor),
            //                                   shape: BoxShape.circle,
            //                                   image: const DecorationImage(
            //                                     fit: BoxFit.cover,
            //                                     image: NetworkImage(
            //                                       "https://bip.cnrs.fr/wp-content/uploads/2019/11/user.jpg",
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ),
            //                             ];
            //                           }
            //                           return Stack(
            //                             children: children,
            //                           );
            //                         },
            //                       ),
            //                       SizedBox(
            //                         width: 16.h,
            //                       ),
            //                       Expanded(
            //                         child: FutureBuilder(
            //                           future: Future.wait([
            //                             _loadUser.then((value) => user = value),
            //                             _loadTickets
            //                                 .then((value) => tickets = value),
            //                           ]),
            //                           builder: (BuildContext context,
            //                               AsyncSnapshot snapshot) {
            //                             List<Widget> children;
            //                             if (snapshot.hasData) {
            //                               children = <Widget>[
            //                                 Text(
            //                                   snapshot.data[0].name,
            //                                   style: GoogleFonts.montserrat(
            //                                       fontSize: 24.sp),
            //                                 ),
            //                               ];
            //                             } else {
            //                               children = <Widget>[
            //                                 Text(
            //                                   '..',
            //                                   style: GoogleFonts.montserrat(),
            //                                 ),
            //                               ];
            //                             }
            //                             return Column(
            //                               crossAxisAlignment:
            //                                   CrossAxisAlignment.start,
            //                               mainAxisSize: MainAxisSize.min,
            //                               children: children,
            //                             );
            //                           },
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         SizedBox(
            //           height: 20.h,
            //         ),
            //         Divider(
            //           color: Colors.black54,
            //           height: 30.h,
            //           thickness: 0.25.h,
            //           indent: 0,
            //           endIndent: 0,
            //         ),
            //         Expanded(
            //           flex: 5,
            //           child: FutureBuilder(
            //             future: Future.wait([
            //               _loadUser.then((value) => user = value),
            //               _loadTickets.then((value) => tickets = value),
            //             ]),
            //             builder: (context, ticketSnap) {
            //               if (ticketSnap.hasData) {
            //                 return ListView.builder(
            //                   scrollDirection: Axis.vertical,
            //                   shrinkWrap: true,
            //                   padding: EdgeInsets.symmetric(
            //                       horizontal: 16.w, vertical: 16.h),
            //                   itemCount: ticketSnap.data[1].length,
            //                   itemBuilder: (context, index) {
            //                     Ticket ticket =
            //                         ticketSnap.data[1]['ticket'][index];
            //                     return SizedBox(
            //                       width: MediaQuery.of(context).size.width,
            //                       child: Column(
            //                         crossAxisAlignment: CrossAxisAlignment.center,
            //                         children: [
            //                           InkWell(
            //                             child: Container(
            //                               padding: EdgeInsets.all(26.r),
            //                               margin: EdgeInsets.fromLTRB(
            //                                   26.w, 26.h, 26.w, 12.h),
            //                               decoration: BoxDecoration(
            //                                 color: Colors.white,
            //                                 borderRadius: BorderRadius.all(
            //                                   Radius.circular(20.r),
            //                                 ),
            //                                 boxShadow: [
            //                                   BoxShadow(
            //                                     color:
            //                                         Colors.black.withOpacity(0.1),
            //                                     spreadRadius: 2.r,
            //                                     blurRadius: 4.r,
            //                                   ),
            //                                 ],
            //                               ),
            //                               child: Column(
            //                                 children: [
            //                                   Column(
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.start,
            //                                     children: [
            //                                       SizedBox(height: 28.h),
            //                                       Text(
            //                                         ticket.dateDeparture,
            //                                         style: TextStyle(
            //                                           fontSize: 25.sp,
            //                                         ),
            //                                       ),
            //                                       SizedBox(height: 28.h),
            //                                       Row(
            //                                         children: [
            //                                           Column(
            //                                             crossAxisAlignment:
            //                                                 CrossAxisAlignment
            //                                                     .start,
            //                                             children: [
            //                                               const Text(
            //                                                 'De',
            //                                                 style: TextStyle(
            //                                                     color:
            //                                                         blueAccent),
            //                                               ),
            //                                               Text(ticket.from),
            //                                               SizedBox(height: 28.h),
            //                                               const Text(
            //                                                 'A',
            //                                                 style: TextStyle(
            //                                                     color:
            //                                                         blueAccent),
            //                                               ),
            //                                               Text(ticket.to),
            //                                             ],
            //                                           ),
            //                                           const Spacer(),
            //                                           Column(
            //                                             crossAxisAlignment:
            //                                                 CrossAxisAlignment
            //                                                     .start,
            //                                             children: [
            //                                               const Text(
            //                                                 'Départ',
            //                                                 style: TextStyle(
            //                                                     color:
            //                                                         blueAccent),
            //                                               ),
            //                                               Text(ticket
            //                                                   .timeDeparture),
            //                                               SizedBox(height: 28.h),
            //                                               const Text(
            //                                                 'Arrivée',
            //                                                 style: TextStyle(
            //                                                     color:
            //                                                         blueAccent),
            //                                               ),
            //                                               Text(
            //                                                   ticket.timeArrival),
            //                                             ],
            //                                           )
            //                                         ],
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ],
            //                               ),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     );
            //                   },
            //                 );
            //               } else {
            //                 return Center(child: CircularProgressIndicator());
            //               }
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
