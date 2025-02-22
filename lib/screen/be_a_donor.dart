import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/custom_dialogs.dart';
import 'home_screen.dart';

class BeADonor extends StatefulWidget {
  const BeADonor({Key? key}) : super(key: key);

  @override
  State<BeADonor> createState() => _BeADonorState();
}

class _BeADonorState extends State<BeADonor> {
  final formkey = GlobalKey<FormState>();

  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late String _name;
  bool _categorySelected = false;
  late String _qty;
  int _radioValue = 0;
  late String _phone;
  List gender = ["Male", "Female", "Other"];

  late String select;

  final List<String> _bloodGroup = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  String _selected = '';

  Future<void> addData(_user) async {
    FirebaseFirestore.instance
        .collection('Donor')
        .doc()
        .set(_user)
        .catchError((e) {
      print(e);
    });
  }

  bool validateSave() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateSubmit(BuildContext context) async {
    if (validateSave()) {
      try {
        CustomDialogs.progressDialog(
            context: context, message: 'Form Submission under process');

        Navigator.pop(context);

        final Map<String, dynamic> userDetails = {
          'uid': _currentUser!.uid,
          'name': _name,
          'bloodgroup': _selected,
          'phoneNumber': _phone,
          'gender': _radioValue == 0
              ? "male"
              : _radioValue == 1
                  ? "female"
                  : "other",
          "quantity": _qty,
        };
        addData(userDetails).then((result) {
          //print("User Added");
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }).catchError((e) {
          print(e);
        });
      } catch (e) {
        print('Errr : $e');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text('Form Submission Failed'),
                content: Text('Error : $e'),
                actions: <Widget>[
                  TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Be A Donor",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        child: Container(
          height: 800.0,
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? "Name field can't be empty"
                              : null,
                          onSaved: (value) => _name = value!,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(18.0),
                      //   child: TextFormField(
                      //     decoration: const InputDecoration(
                      //       hintText: 'Email ID',
                      //       icon: Icon(
                      //         FontAwesomeIcons.envelope,
                      //         color: Color.fromARGB(1000, 221, 46, 68),
                      //       ),
                      //     ),
                      //     validator: (value) => value!.isEmpty
                      //         ? "Email ID field can't be empty"
                      //         : null,
                      //     onSaved: (value) => _email = value!.trim(),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(18.0),
                      //   child: TextFormField(
                      //     decoration: const InputDecoration(
                      //       hintText: 'Password',
                      //       icon: Icon(
                      //         FontAwesomeIcons.userLock,
                      //         color: Color.fromARGB(1000, 221, 46, 68),
                      //       ),
                      //     ),
                      //     obscureText: true,
                      //     validator: (value) => value!.isEmpty
                      //         ? "Password field can't be empty"
                      //         : null,
                      //     onSaved: (value) => _password = value!,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Gender Preferences",
                        style: TextStyle(
                            color: const Color(0xFFB1B1B3),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        dense: true,
                        title: Text(
                          "Male",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        trailing: Radio<int>(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: (value) {
                            setState(() {
                              _radioValue = value!;
                            });
                          },
                          activeColor: const Color(0xFF00608d),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: Text(
                          "Female",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        trailing: Radio<int>(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (value) {
                            setState(() {
                              _radioValue = value!;
                            });
                          },
                          activeColor: const Color(0xFF00608d),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        title: Text(
                          "Other",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        trailing: Radio<int>(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: (value) {
                            setState(() {
                              _radioValue = value!;
                            });
                          },
                          activeColor: const Color(0xFF00608d),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: DropdownButton(
                          hint: const Text(
                            'Please choose a Blood Group',
                            style: TextStyle(
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          iconSize: 40.0,
                          items: _bloodGroup.map((val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(
                              () {
                                _selected = newValue as String;
                                _categorySelected = true;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        _selected,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Color.fromARGB(1000, 221, 46, 68),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: '1 packet (300 ml)',
                            icon: Icon(
                              FontAwesomeIcons.prescriptionBottle,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Quantity field can't be empty";
                            }

                            if (int.parse(value) > 300) {
                              return "Blood unit can't be greater than 300 pack";
                            }

                            return null;
                          },
                          onSaved: (value) => _qty = value!,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Phone Number',
                            icon: Icon(
                              FontAwesomeIcons.mobile,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? "Phone Number field can't be empty"
                              : null,
                          onSaved: (value) => _phone = value!,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      TextButton(
                        onPressed: () => validateSubmit(context),
                        child: const Text("Be A Donor"),
                      ),
                    ],
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
