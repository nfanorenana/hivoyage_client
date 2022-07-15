import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/pages/personal_settings.dart';
import 'package:hivoyage/pages/security_settings.dart';
import 'package:hivoyage/providers/auth.dart';
import 'package:hivoyage/providers/user_provider.dart';
import 'package:hivoyage/util/storage.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    doLogout() {
      final Future<Map<String, dynamic>> successfulMessage =
          AuthProvider().logout();

      successfulMessage.then((response) {
        if (response['status']) {
          Provider.of<UserProvider>(context, listen: false).user = null;
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Flushbar(
            title: "Erreur",
            message: response['message'].toString(),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      });
    }

    return ScreenUtilInit(
      builder: () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
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
        body: Container(
          padding: EdgeInsets.only(left: 16.w, top: 25.h, right: 16.w),
          child: ListView(
            children: [
              Text(
                "Paramètres",
                style: GoogleFonts.montserrat(
                    fontSize: 25.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Comptes",
                    style: GoogleFonts.montserrat(
                        fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Divider(
                height: 15.h,
                thickness: 2,
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () async {
                  User user = await UserPreferences().getUser();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PersonalSettings(user: user),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informations personnelles',
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Icon(
                        Icons.mode_edit_outline_outlined,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  User user = await UserPreferences().getUser();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SecuritySettings(user: user),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informations de sécurité',
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Icon(
                        Icons.mode_edit_outline_outlined,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Se déconnecter',
          backgroundColor: Colors.red,
          child: const Icon(Icons.logout),
          onPressed: () => doLogout(),
        ),
      ),
      designSize: const Size(480, 640),
    );
  }
}
