import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/widget/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.isFirst});
  final bool isFirst;
  @override
  State<EditProfile> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  var _enterdName = '';
  var _enteredUsername = '';
  var _enteredBio = '';
  File? _selectedImage;
  var _isUploding = false;

  void _submit() async {
    final _isValid = _formKey.currentState!.validate();

    if (!_isValid || _selectedImage == null) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isUploding = true;
    });
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user')
        .child('user_image')
        .child('@$_enteredUsername-ProfilePic.jpg');

    await storageRef.putFile(_selectedImage!);
    setState(() {
      _isUploding = false;
    });
    final imageUrl = await storageRef.getDownloadURL();
    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final bool _firstTime = widget.isFirst;
    return Scaffold(
      appBar: AppBar(
        title: Text(_firstTime ? 'Complete Your Account' : 'Account Edit '),
      ),
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
                      UserImagePicker(
                        onPickImage: (pickedImage) {
                          _selectedImage = pickedImage;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          label: const Text(
                            'Full Name',
                            style: TextStyle(fontSize: 17),
                          ),
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.length < 2) {
                            return 'Please Enter a Valid Name';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enterdName = newValue!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          label: const Text(
                            'Username',
                            style: TextStyle(fontSize: 17),
                          ),
                          prefixIcon: const Icon(Icons.alternate_email),
                          prefixText: "@",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter a Valid Username';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enteredUsername = newValue!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          label: const Text(
                            'Bio',
                            style: TextStyle(fontSize: 17),
                          ),
                          prefixIcon: const Icon(Icons.info_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.length < 5) {
                            return 'Please Enter a Valid Bio';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _enteredBio = newValue!;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_isUploding) const CircularProgressIndicator(),
                      if (!_isUploding)
                        ElevatedButton(
                          onPressed: _submit,
                          child:
                              Text(_firstTime ? 'Continue' : 'Update Profile'),
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
