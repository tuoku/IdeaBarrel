import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ideabarrel/repos/auth_repo.dart';
import 'package:ideabarrel/repos/cosmos_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../repos/storage_repo.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final userId = const Uuid().v4();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? img;
  String? imgUrl;
  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 44, 143, 224),
                Color.fromARGB(255, 18, 195, 226)
              ]),
            ),
            padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Register",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name*",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Add a photo",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                    alignment: Alignment.center,
                    child: img != null
                        ? Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 10,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image(
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  image: FileImage(File(img!.path)),
                                )))
                        : InkWell(
                            onTap: () async {
                              final XFile? photo = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      title: const Text("Add photo"),
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  final XFile? p =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 75);
                                                  Navigator.pop(context, p);
                                                },
                                                child: Column(
                                                  children: const [
                                                    Icon(
                                                      Icons.photo_camera,
                                                      size: 40,
                                                    ),
                                                    Text("from camera")
                                                  ],
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  final XFile? p =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 75);
                                                  Navigator.pop(context, p);
                                                },
                                                child: Column(
                                                  children: const [
                                                    Icon(
                                                      Icons.photo,
                                                      size: 40,
                                                    ),
                                                    Text("from gallery")
                                                  ],
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    );
                                  });

                              if (photo != null) {
                                StorageRepo()
                                    .uploadImage(photo, widget.userId)
                                    .then((value) {
                                  setState(() {
                                    img = photo;
                                    imgUrl = value;
                                  });
                                });
                              }
                            },
                            child: const Card(
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                  )),
                            ))),
                const SizedBox(
                  height: 40,
                ),
                Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          if (_nameController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });
                            CosmosRepo()
                                .registerUser(
                                    widget.userId, _nameController.text)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              if (value) {
                                AuthRepo().logIn(widget.userId);
                              }
                            });
                          }
                        },
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                "Register!",
                                style: TextStyle(color: Colors.black),
                              )))
              ],
            )));
  }
}
