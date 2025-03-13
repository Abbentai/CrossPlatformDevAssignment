import 'package:flutter/material.dart';
import 'package:manga_tracking_app/views/form.dart';
import 'package:manga_tracking_app/widgets/manga_card.dart';

class HomeScreen extends StatelessWidget {
  //Used to navigate to form screen
  void _creationForm(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => FormScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Manga Tracking App"),
      ),
      body: Center(
          child: GridView(
        padding: EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 5 / 8,
        ),
        //These are temporarily just loaded via parameters for now with discord image links, these will eventually images store locally taken from the camera
        children: [
          MangaCard(
            name: "FullMetal Alchemist Vol. 1",
            imageURL:
                'https://cdn.discordapp.com/attachments/758289671591034910/1349865020158119996/PXL_20250313_220130992.jpg?ex=67d4a744&is=67d355c4&hm=510d0bdd6d3e559ae776b7fe9d3dbd06ed74e34163cfaa2ce2208625a06aa0ab&',
          ),
          MangaCard(
            name: "Kagurabachi Vol. 1 ",
            imageURL:
                'https://cdn.discordapp.com/attachments/758289671591034910/1349867607959932928/PXL_20250313_221042056.jpg?ex=67d4a9ad&is=67d3582d&hm=50e2ee1f19e37ed0e5989408173f7d50cb049a65270702889e9959250a08c0cb&',
          ),
          MangaCard(
            name: "Death Note Vol. 1",
            imageURL:
                'https://cdn.discordapp.com/attachments/758289671591034910/1349867607259349042/PXL_20250313_221020592.MP.jpg?ex=67d4a9ac&is=67d3582c&hm=e7e56440b8b065b4c6cd0d8eabf80749e8e7b1d93cb377f22642960a677ff348&',
          ),
          MangaCard(
            name: "Chainsaw Man Vol. 1",
            imageURL:
                'https://cdn.discordapp.com/attachments/758289671591034910/1349867608798658600/PXL_20250313_221104917.MP2.jpg?ex=67d4a9ad&is=67d3582d&hm=dcb2a51cb32fb735c887d824d610b081ebb968403805215b431a452cacb52f98&',
          ),
          MangaCard(
            name: "Empty Test",
            imageURL: '',
          ),
          MangaCard(
            name: "Empty Test",
            imageURL: '',
          ),
          MangaCard(
            name: "Empty Test",
            imageURL: '',
          ),
          MangaCard(
            name: "Empty Test",
            imageURL: '',
          ),
        ],
      )),

      //FAB button to add a new manga, sized box is for a custom FAB scale
      floatingActionButton: SizedBox(
        height: 72,
        width: 72,
        child: FittedBox(
            child: FloatingActionButton(
          onPressed: () => _creationForm(context),
          tooltip: 'Create New Manga',
          child: const Icon(Icons.add),
        )),
      ),
    );
  }
}
