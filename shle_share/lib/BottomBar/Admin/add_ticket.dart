import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/onBoarding/on_boarding.dart';
import 'package:shle_share/widget/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AddTicket extends StatefulWidget {
  AddTicket({super.key});

  @override
  State<AddTicket> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<AddTicket> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTicketText = '';

  var _isUploding = false;

  var TicketController = TextEditingController();

  void _submit() async {
    final _isValid = _formKey.currentState!.validate();

    if (!_isValid) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    _formKey.currentState!.save();
    setState(() {
      _isUploding = true;
    });

    await FirebaseFirestore.instance.collection('Tickets').doc(user.uid).set({
      'TicketText': _enteredTicketText,
      'userId': user.uid,
      'createdAt': Timestamp.now(),
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    dispose() {
      TicketController.dispose();
      super.dispose();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      const Text(
                          'Please write a ticket explaining why your account should not be suspended.'),
                      const SizedBox(height: 20),
                      TextFormField(
                        maxLines: null,
                        minLines: 1,
                        controller: TicketController,
                        decoration: InputDecoration(
                          label: const Text(
                            'Ticket',
                            style: TextStyle(fontSize: 17),
                          ),
                          prefixIcon: const Icon(Icons.info),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.length < 2) {
                            return 'Please Enter a Valid Ticket 5+ char';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enteredTicketText = newValue!;
                        },
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 20),
                      if (_isUploding) const CircularProgressIndicator(),
                      if (!_isUploding)
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Send Ticket'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
