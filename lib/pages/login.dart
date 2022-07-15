import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/providers/auth.dart';
import 'package:hivoyage/providers/user_provider.dart';
import 'package:hivoyage/util/validators.dart';
import 'package:hivoyage/util/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      validator: validateEmail,
      onSaved: (value) => _email = value,
      decoration: buildInputDecoration("Adresse email", Icons.email),
      keyboardType: TextInputType.emailAddress,
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          value.isEmpty ? "Veuillez entrer le mot de passe" : null,
      onSaved: (value) => _password = value,
      decoration: buildInputDecoration("Mot de passe", Icons.lock),
      keyboardType: TextInputType.text,
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // TextButton(
        //   onPressed: () {
        //     // Navigator.pushReplacement(context,PassengerSignup())
        //   },
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text(
        //         "Mot de passe oublié ",
        //         style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        //       ),
        //     ],
        //   ),
        // ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Inscrivez-vous ici",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );

    doLogin() {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        final Future<Map<String, dynamic>> res = auth.login(_email, _password);

        res.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).user = user;
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Flushbar(
              title: "Tentative de connexion échoué",
              message: response['message'].toString(),
              duration: const Duration(seconds: 2),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Formulaire invalide",
          message: "Vueillez remplir correctement le formulaire",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

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
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 36.0.h, horizontal: 24.0.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connexion',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 32.0.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
                      padding: EdgeInsets.all(24.0.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            emailField,
                            SizedBox(
                              height: 20.0.h,
                            ),
                            passwordField,
                            SizedBox(
                              height: 20.0.h,
                            ),
                            auth.loggedInStatus == Status.Authenticating
                                ? loading
                                : longButtons(
                                    title: "Se connecter",
                                    fun: doLogin,
                                    color: Colors.black38),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Divider(
                                    height: 40.h,
                                    thickness: 2,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                              ],
                            ),
                            forgotLabel
                          ],
                        ),
                      ),
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
