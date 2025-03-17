import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:manga_tracking_app/views/viewbook.dart';

class MangaCard extends StatelessWidget {
  const MangaCard(
      {super.key,
      required this.name,
      required this.volumeNum,
      required this.image,
      required this.viewBook});

  final String name;
  final int volumeNum;
  final String? image;
  final void Function() viewBook;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Decoding base64 string To a Uint8list for Image.memory to display
    Uint8List? imageBytes;
    if (image != null && image!.isNotEmpty) {
      try {
        imageBytes = base64Decode(image!);
      } catch (e) {
        debugPrint("Error decoding base64 image: $e");
        imageBytes = null;
      }
    }

    bool isImageLoading = true;

    return InkWell(
        onTap: viewBook,
        splashColor: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              //Changes colour scheme depending on theme
              color: isDarkMode
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.primaryContainer,
            ),
            //Layout builder is so that the images can use maxWidth and maxHeight of the parent class which in this case is the InkWell
            child: LayoutBuilder(
                builder: (_, constraints) => Stack(children: [
                      // Image section
                      if (imageBytes != null && image!.isNotEmpty)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (isImageLoading)
                                  const CircularProgressIndicator(),
                                Image.memory(
                                  imageBytes,
                                  fit: BoxFit.cover,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Gradient overlay
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 80,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(0, 0, 0, 0),
                                  Color.fromARGB(100, 0, 0, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '$name Vol. $volumeNum',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      )
                    ]))));
  }
}
