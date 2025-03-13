import 'package:flutter/material.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({super.key, required this.name, required this.imageURL});

  final String name;
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
        onTap: () {},
        splashColor: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: isDarkMode
                  ? Theme.of(context).colorScheme.onSecondary // Dark mode color
                  : Theme.of(context).colorScheme.primaryContainer,
              image: DecorationImage(
                image: NetworkImage(imageURL),
                fit: BoxFit
                    .cover, // Ensures the image covers the entire container
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 80,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(0, 0, 0, 0),
                            Color.fromARGB(100, 0, 0, 0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                    ),
                  )),
            )));
  }
}
