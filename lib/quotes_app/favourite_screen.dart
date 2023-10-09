import 'package:flutter/material.dart';
import 'package:quotes_app/quotes_app/translate.dart';

class FavouriteScreen extends StatefulWidget {
   List favourite = [];
   Map data = {};
   int index = 0;
    FavouriteScreen({super.key,required this.favourite,required this.data,required this.index});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.favourite.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(right: 5, left: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all()),
          child: Column(
            children: [
              textToTrans(
                  input: "${widget.favourite[index]}",
                  style: const TextStyle(fontSize: 20)),
              /*IconButton(
                  onPressed: () {
                    widget.data["_data"][widget.index]["favourite"] = false;
                    widget.favourite.removeAt(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.favorite,color: Colors.red,)),*/
            ],
          ),
        );
      },
    );
  }
}
