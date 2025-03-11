import 'package:flutter/material.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Theme.of(context).colorScheme.tertiary,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface))),
      ),
    );
  }
}
