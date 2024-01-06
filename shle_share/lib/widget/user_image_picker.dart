import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;
  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 75,
        backgroundColor: Colors.grey,
        foregroundImage:
            (_pickedImageFile != null) ? FileImage(_pickedImageFile!) : null,
        child: Container(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Container(
            height: 40,
            width: double.infinity,
            color: Colors.black54,
            child: Center(
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
