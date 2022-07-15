import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hivoyage/constants/constants.dart';
import 'package:hivoyage/domain/user.dart';
import 'package:hivoyage/providers/services.dart';
import 'package:hivoyage/util/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PersonalSettings extends StatefulWidget {
  User user;
  PersonalSettings({Key key, this.user}) : super(key: key);

  @override
  _PersonalSettingsState createState() => _PersonalSettingsState();
}

class _PersonalSettingsState extends State<PersonalSettings> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController contactCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pswCtrl = TextEditingController();

  File profilePhoto;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      profilePhoto = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      profilePhoto = image;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.user.name =
        null ? nameCtrl.text = widget.user.name : nameCtrl.text = '';
    widget.user.username = null
        ? usernameCtrl.text = widget.user.username
        : usernameCtrl.text = '';
    widget.user.email =
        null ? emailCtrl.text = widget.user.email : emailCtrl.text = '';
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Galérie photo'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Caméra'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    modify() {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        final Future<Map<String, dynamic>> res = updatePersonalInformations(
            nameCtrl.text, usernameCtrl.text, contactCtrl.text, emailCtrl.text);

        res.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Modification",
              message: response['message'].toString(),
              duration: const Duration(seconds: 2),
            ).show(context);
            Navigator.of(context).pop();
          } else {
            Flushbar(
              title: "Modification",
              message: response['message'].toString(),
              duration: const Duration(seconds: 2),
            ).show(context);
          }
        });
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
          'Informations personnelles',
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
                  "Informations",
                  style: GoogleFonts.montserrat(
                      fontSize: 25.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: blue,
                      child: profilePhoto != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25.r),
                              child: Image.file(
                                profilePhoto,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: nameCtrl,
                  validator: (value) => value.isEmpty ? "Nom requis" : null,
                  decoration:
                      buildInputDecoration("Nom", CupertinoIcons.person_solid),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: usernameCtrl,
                  validator: (value) =>
                      value.isEmpty ? "Nom d'utilisateur requis" : null,
                  decoration: buildInputDecoration(
                      "Nom d'utilisateur", CupertinoIcons.person_solid),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  controller: contactCtrl,
                  decoration:
                      buildInputDecoration("Contact", Icons.contact_phone),
                ),
                SizedBox(
                  height: 15.h,
                ),
                TextFormField(
                  readOnly: true,
                  controller: emailCtrl,
                  decoration:
                      buildInputDecoration("Adresse email", Icons.email),
                ),
                SizedBox(
                  height: 22.h,
                ),
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
