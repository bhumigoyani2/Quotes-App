
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/quotes_app/flutter_toast.dart';
import 'package:quotes_app/quotes_app/permission.dart';
import 'package:quotes_app/quotes_app/test_to_speech_.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dark_theme.dart';
import 'favourite_screen.dart';
import 'rating.dart';
import 'translate.dart';

class Quotes extends StatefulWidget {
  final SharedPreferences prefs;
  Map data = {};
  Map quotes = {};

  Quotes(
      {super.key,
      required this.prefs,
      required this.quotes,
      required this.data});

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  int count = 0;
  bool get = false;
  int selectIndex = 0;
  List favouriteList = [];
  var _currentIndex = 0;
  String _englishText = 'Hello'; // English text to be translated
  String _gujaratiTranslation = '';

  //share on social media
  void _shareContent(String content) {
    Share.share(content);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
    // Load the previous count value from SharedPreferences
    count = widget.prefs.getInt('count') ?? 0;

    // Check if the app was last opened more than a minute ago
    final lastOpenTime = widget.prefs.getInt('lastOpenTime') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - lastOpenTime > 60000) {
      // Reset count if more than a minute has passed
      count = 0;
    } else {
      count++;
      setState(() {});
    }
    widget.prefs.setInt('count', count);
    widget.prefs.setInt('lastOpenTime', DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: Scaffold(
        appBar: AppBar(title: textToTrans(input: "Quotes     $count")),
        body: get == true
            ? Center(child: CircularProgressIndicator())
            : [
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                    itemCount: widget.data['_data'].length,
                    itemBuilder: (context, index) {
                      // index = Random().nextInt(widget.data['_data'].length);
                      // print("***********$index");
                      return Container(
                        height: 140,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: Column(
                            children: [
                              textToTrans(
                                  input:
                                      "${widget.data["_data"][index]["title"]}",
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    overflow: TextOverflow.visible,
                                  )),
                              Row(
                                children: [Spacer(),
                                  IconButton(
                                      onPressed: () async {
                                        _englishText = widget.data["_data"][index]['title'];
                                        final translation =
                                        await translator.translate(_englishText, from: 'en', to: languageCode);
                                        setState(() {
                                          _gujaratiTranslation = translation.text;
                                        });
                                        await Clipboard.setData(ClipboardData(
                                            text: _gujaratiTranslation
                                        ));
                                       flutterToast("Copied to Clipboard");
                                      },
                                      icon: const Icon(Icons.copy)),
                                  IconButton(
                                      onPressed: () {
                                        selectIndex = index;
                                        widget.data["_data"][index]["favourite"] =
                                            !widget.data["_data"][index]
                                                ["favourite"];
                                        if (widget.data["_data"][index]
                                                ["favourite"] ==
                                            true) {
                                          favouriteList.add(
                                              widget.data["_data"][index]["title"]);
                                        } else {
                                          favouriteList.remove(
                                              widget.data["_data"][index]["title"]);
                                        }
                                        setState(() {});
                                      },
                                      icon: widget.data["_data"][index]
                                                  ["favourite"] ==
                                              true
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.favorite_border)),
                                  IconButton(
                                      onPressed: () async {
                                        _englishText = widget.data["_data"][index]['title'];
                                        final translation =
                                            await translator.translate(_englishText, from: 'en', to: languageCode);
                                        setState(() {
                                          _gujaratiTranslation = translation.text;
                                        });
                                        speakQuote(languageCode,_gujaratiTranslation);
                                        print(_gujaratiTranslation);
                                        print("-------$languageCode-----");
                                        setState(() {

                                        });
                                      },
                                      icon: const Icon(Icons.volume_up_rounded)),
                                  IconButton(
                                      onPressed: () async {
                                        _englishText = widget.data["_data"][index]["title"];
                                        final translation =
                                            await translator.translate(_englishText, from: 'en', to: languageCode);
                                        setState(() {
                                          _gujaratiTranslation = translation.text;
                                        });
                                        String sharedContent =
                                            "$_gujaratiTranslation\n${widget.quotes['app_name']}\n${widget.quotes["share_app_url"]}";
                                        _shareContent(sharedContent);
                                      },
                                      icon: const Icon(Icons.share)),
                                ],
                              )
                            ],
                          ));
                    }),
                FavouriteScreen(
                    favourite: favouriteList,
                    data: widget.data,
                    index: selectIndex),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      buildOutlinedButton("en", "English"),
                      buildOutlinedButton("es", "Spanish"),
                      buildOutlinedButton("gu", "Gujarati"),
                      buildOutlinedButton("fr", "French"),
                      buildOutlinedButton("de", "German"),
                      buildOutlinedButton("hi", "Hindi"),
                    ],
                  ),
                ),
                Rating(data: widget.quotes),
              ].elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.language), label: "Language"),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border), label: "Rating"),
          ],
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }

  OutlinedButton buildOutlinedButton(String code, String languageName) {
    return OutlinedButton(
        onPressed: () async {
          languageCode = code;
          setState(() {

          });
        },
        child: Text(languageName));
  }
}