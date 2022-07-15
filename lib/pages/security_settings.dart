import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/util/widgets.dart';

class SecuritySettings extends StatefulWidget {
  User user;
  SecuritySettings({Key key, this.user}) : super(key: key);

  @override
  _SecuritySettingsState createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController pswCtrl = TextEditingController();
  final TextEditingController newPswCtrl = TextEditingController();
  final TextEditingController confirmNewPswCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    modify() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
      } else {
        Flushbar(
          title: "Formulaire invalide",
          message: "Vueillez remplir correctement le formulaire",
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Informations de sécurité',
          style: GoogleFonts.montserrat(color: blueAccent, fontSize: 22.0.sp),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: blueAccent,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0.h,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Container(
          padding: EdgeInsets.all(5.r),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Text(
                  "Sécurité",
                  style: GoogleFonts.montserrat(
                      fontSize: 25.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 22.h,
                ),
                TextFormField(
                  controller: pswCtrl,
                  validator: (value) =>
                      value.isEmpty ? "Mot de passe requis" : null,
                  decoration: buildInputDecoration("Mot de passe", Icons.lock),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: newPswCtrl,
                  validator: (val) {
                    if (val.isEmpty) return 'Nouveau mot de passe requis';
                    return null;
                  },
                  decoration:
                      buildInputDecoration("Nouveau mot de passe", Icons.lock),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: confirmNewPswCtrl,
                  validator: (val) {
                    if (val.isEmpty) return 'Confirmation requise';
                    if (val != newPswCtrl.text) {
                      return 'Les mots de passe que vous avez entrés ne sont pas identiques';
                    }
                    return null;
                  },
                  decoration: buildInputDecoration(
                      "Confirmation mot de passe", Icons.lock),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueAccent,
        // foregroundColor: primaryColor.shade50,
        tooltip: 'Vérifier',
        child: const Icon(Icons.check),
        onPressed: () => modify(),
      ),
    );
  }
}
