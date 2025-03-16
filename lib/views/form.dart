import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:manga_tracking_app/model/book.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewBookState();
  }
}

class _NewBookState extends State<FormScreen> {
  //Db reference and formKey for the state of the form
  final _formKey = GlobalKey<FormState>();

  //vars for storing input
  var _title = '';
  var _volumeNum = 1;
  var _author = '';
  var _isbn;
  var _date = DateTime.now();
  var _demographic = '';
  var _publisher = '';
  var _chapters = 1;
  var _pages = 0;
  var _image;

  var isSendingData = false;

  //Future method which brings up the camera functionality and saves it as a File
  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );

    if (returnedImage == null) return;

    setState(() {
      _image = File(returnedImage.path);
    });
  }

  //Async method which
  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        _formKey.currentState!.save();

        setState(() {
          isSendingData = true;
        });

        // await Firebase.initializeApp();
        String? base64Image = "test";
        if (_image != null){
          List<int> imageBytes = await _image!.readAsBytes();
          base64Image = base64Encode(imageBytes);
        } else {
          base64Image = "";
        }

        final url = Uri.https(
            "mangatrackercpdassignment-default-rtdb.europe-west1.firebasedatabase.app",
            'book-list.json');

        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'title': _title,
              'volumeNum': _volumeNum,
              'author': _author,
              'isbn': _isbn,
              'date': _date.toIso8601String(),
              'demographic': _demographic,
              'publisher': _publisher,
              'chapters': _chapters,
              'pages': _pages,
              'image': base64Image,
            }));

        print(response.statusCode);
        print(response.body);

        Map<String, dynamic> responseData = json.decode(response.body);

        if ((!context.mounted)) {
          return;
        }

        Navigator.of(context).pop(Book(
            id: 'testidfk${DateTime.now()}',
            title: _title,
            volumeNum: _volumeNum,
            author: _author,
            isbn: _isbn,
            date: _date,
            demographic: _demographic,
            publisher: _publisher,
            chapters: _chapters,
            pages: _pages,
            image: base64Image));
      } catch (e) {
        setState(() {
          isSendingData = false;
        });
        print("Error uploading book: $e");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Error uploading book: $e")),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Add New Manga"),
        ),
        body: ScrollbarTheme(
            data: ScrollbarThemeData(
                interactive: true,
                radius: Radius.circular(10),
                thumbColor: WidgetStatePropertyAll(
                  Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.2), // Adjust opacity here
                )),
            child: Scrollbar(
                thickness: 10,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //Title Field
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Title *'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title is Required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Author *'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Author is Required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _author = value!;
                          },
                        ),
                        //Volume Number and ISBN Fields
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //quantity
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text('Vol No. *'),
                                ),
                                initialValue: '1',
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null) {
                                    return 'Volume Number is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _volumeNum = int.parse(value!);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text('ISBN *'),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null ||
                                      int.tryParse(value)! <= 0) {
                                    return 'An ISBN must be entered';
                                  } else if (value.length != 10 &&
                                      value.length != 13) {
                                    return 'An ISBN must be 10 or 13 digits long';
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _isbn = value!;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            //category
                          ],
                        ),
                        TextFormField(
                          //Controller is needed to update the text field with the parsed date
                          controller: TextEditingController(
                            text: _date != null
                                ? "${_date.toLocal()}".split(' ')[0]
                                : '',
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Date Released *',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null && pickedDate != _date) {
                              setState(() {
                                _date = pickedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 50,
                        ),

                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Demographic *'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Demographic is Required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _demographic = value!;
                          },
                        ),

                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Publisher *'),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Publisher is Required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _publisher = value!;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //quantity
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text('Chapters *'),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null) {
                                    return 'Amount of chapters is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _chapters = int.parse(value!);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  label: Text('Pages *'),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null) {
                                    return 'Amount of pages is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _pages = int.parse(value!);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            //category
                          ],
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        ElevatedButton.icon(
                            onPressed: _pickImageFromCamera,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Capture Image"),
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Theme.of(context)
                                        .colorScheme
                                        .inversePrimary))),

                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: _image == null
                              ? EdgeInsets.all(50)
                              : EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onSecondary // Dark mode color
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(_image!))
                              : const Text("No cover art currently taken"),
                        ),

                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _formKey.currentState!.reset();
                                },
                                child: const Text('Reset')),
                            ElevatedButton(
                                onPressed: _saveBook,
                                child: isSendingData
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator())
                                    : const Text('Submit')),
                          ],
                        )
                      ],
                    ),
                  ),
                )))));
  }
}
